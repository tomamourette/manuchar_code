# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "jupyter",
# META     "jupyter_kernel_name": "python3.11"
# META   },
# META   "dependencies": {
# META     "lakehouse": {
# META       "default_lakehouse": "a3c7dd8f-25f9-4aa9-aaad-981087e7d0d4",
# META       "default_lakehouse_name": "dbb_lakehouse",
# META       "default_lakehouse_workspace_id": "913a2dc2-5f68-4fb7-ab07-631a84561fd6",
# META       "known_lakehouses": [
# META         {
# META           "id": "a3c7dd8f-25f9-4aa9-aaad-981087e7d0d4"
# META         }
# META       ]
# META     }
# META   }
# META }

# PARAMETERS CELL ********************

# These parameters will be replaced at runtime

workspace_id = ""
model_id = "" 
data_product = ""
orchestration_run_id = ""
data_product_refresh_pipeline_run_id = ""
data_product_refresh_pipeline_id = ""
model_workspace_id = ""

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "jupyter_python"
# META }

# CELL ********************

import pandas as pd
import sempy.fabric as fabric
from datetime import datetime

# Fetch semantic model refresh requests
refresh_list = fabric.list_refresh_requests(
    workspace=model_workspace_id,
    dataset=model_id,
    top_n=1
)

# Convert to Pandas DataFrame
df_final = pd.DataFrame(refresh_list)

# Flatten & enrich DataFrame
df_final['process_started_at'] = pd.to_datetime(df_final['Start Time'])
df_final['process_completed_at'] = pd.to_datetime(df_final['End Time'])
df_final['duration'] = (df_final['process_completed_at'] - df_final['process_started_at']).dt.total_seconds()

# 🔍 Resolve dataset (semantic model) name
semantic_model_name = fabric.resolve_dataset_name(
    dataset_id=model_id,
    workspace=model_workspace_id
)

# Add metadata fields
df_final['workspace_id'] = model_workspace_id
df_final['semantic_model_id'] = model_id
df_final['data_product'] = data_product
df_final['orchestration_run_id'] = orchestration_run_id
df_final['execution_timestamp'] = pd.Timestamp.now()
df_final['data_product_refresh_pipeline_run_id'] = data_product_refresh_pipeline_run_id
df_final['data_product_refresh_pipeline_id'] = data_product_refresh_pipeline_id
df_final['semantic_model_name'] = semantic_model_name

# Keep only columns needed for Warehouse
df_final = df_final[[ 
    'workspace_id',
    'semantic_model_id',
    'data_product',
    'orchestration_run_id',
    'process_started_at',
    'process_completed_at',
    'duration',
    'Status',
    'execution_timestamp',
    'data_product_refresh_pipeline_run_id',
    'data_product_refresh_pipeline_id',
    'semantic_model_name'
]].rename(columns={'Status': 'status'})

# Display DataFrame
display(df_final)


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "jupyter_python"
# META }

# CELL ********************

# Connect to Fabric Warehouse
conn = notebookutils.data.connect_to_artifact(
    "dbb_warehouse",
    workspace_id,
    "Warehouse"
)

# Create the table if it doesn't exist
create_table_sql = """
    IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'meta')
        EXEC('CREATE SCHEMA meta');

    IF OBJECT_ID('meta.monitoring_semantic_model_refresh', 'U') IS NULL
    BEGIN
        CREATE TABLE meta.monitoring_semantic_model_refresh (
            workspace_id VARCHAR(100),
            semantic_model_id VARCHAR(100),
            data_product VARCHAR(100),
            orchestration_run_id VARCHAR(100),
            process_started_at DATETIME2(3),
            process_completed_at DATETIME2(3),
            duration BIGINT,
            status VARCHAR(50),
            data_product_refresh_pipeline_run_id VARCHAR(100),
            data_product_refresh_pipeline_id VARCHAR(100),
            semantic_model_name VARCHAR(100)
        );
    END
"""

try:
    conn.execute(create_table_sql)
    conn.commit()
    print("✅ Table 'meta.monitoring_semantic_model_refresh' is ready.")
except Exception as e:
    print(f"❌ Failed to create table. Error: {str(e)}")

# Insert rows
insert_sql = """
INSERT INTO [meta].[monitoring_semantic_model_refresh] (
    workspace_id,
    semantic_model_id,
    data_product,
    orchestration_run_id,
    process_started_at,
    process_completed_at,
    duration,
    status,
    data_product_refresh_pipeline_run_id,
    data_product_refresh_pipeline_id,
    semantic_model_name
)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
"""

try:
    for _, row in df_final.iterrows():
        conn.execute(insert_sql,
            row['workspace_id'],
            row['semantic_model_id'],
            row['data_product'],
            row['orchestration_run_id'],
            row['process_started_at'],
            row['process_completed_at'],
            int(row['duration']) if pd.notnull(row['duration']) else None,
            row['status'],
            row['data_product_refresh_pipeline_run_id'],
            row['data_product_refresh_pipeline_id'],
            row['semantic_model_name']
        )
    conn.commit()
    conn.close()
    print("✅ Successfully logged semantic model refresh monitor info")

except Exception as e:
    print(f"❌ Failed to log semantic model refresh monitor info. Error: {str(e)}")


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "jupyter_python"
# META }
