# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {
# META     "lakehouse": {
# META       "default_lakehouse": "a3c7dd8f-25f9-4aa9-aaad-981087e7d0d4",
# META       "default_lakehouse_name": "dbb_lakehouse",
# META       "default_lakehouse_workspace_id": "913a2dc2-5f68-4fb7-ab07-631a84561fd6"
# META     },
# META     "environment": {
# META       "environmentId": "b8214431-5da4-8fdf-43bc-f926235f920f",
# META       "workspaceId": "00000000-0000-0000-0000-000000000000"
# META     }
# META   }
# META }

# PARAMETERS CELL ********************

# These parameters will be replaced at runtime

environment = ""
models = ""
data_product = "" 
orchestration_run_id = ""
transformation_pipeline_run_id = ""
transformation_pipeline_id = ""

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from datetime import datetime
import os

# Generate current UTC timestamp formatted as yyyyMMddHHmmssffffff
transformation_timestamp = datetime.utcnow().strftime("%Y%m%d%H%M%S%f")

# Install necessary packages --> handled by dbb custom environment
# !pip install dbt-fabric==1.7.4

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark",
# META   "frozen": false,
# META   "editable": true
# META }

# CELL ********************

if environment == 'qual':
    
    # Temp Solution: If ENV is Qual, use the PRD KV and QUAL Endpoint 
    key_vault_environment = f"https://be-kv-dbb-prd.vault.azure.net/"

    # Retrieve the required credentials from the environment Key Vault
    try:
        os.environ["AZURE_CLIENT_ID"] = mssparkutils.credentials.getSecret(key_vault_environment, 'FAB-DBB-DBT-SPN-CLIENT-ID') 
        os.environ["AZURE_CLIENT_SECRET"] = mssparkutils.credentials.getSecret(key_vault_environment, 'FAB-DBB-DBT-SPN-CLIENT-SECRET')
        os.environ["AZURE_TENANT_ID"] = mssparkutils.credentials.getSecret(key_vault_environment, 'FAB-DBB-DBT-SPN-TENANT-ID')
        os.environ['FAB_DBB_DBT_ENDPOINT'] = mssparkutils.credentials.getSecret(key_vault_environment, 'FAB-DBB-DBT-ENDPOINT-QUAL')

        print("✅ Successfully retrieved secrets from Key Vault")
    except Exception as e:
        print(f"❌ Failed to retrieve secrets from Key Vault: {e}")
        raise

else:
    key_vault_environment = f"https://be-kv-dbb-{environment}.vault.azure.net/"

    # Retrieve the required credentials from the environment Key Vault
    try:
        os.environ["AZURE_CLIENT_ID"] = mssparkutils.credentials.getSecret(key_vault_environment, 'FAB-DBB-DBT-SPN-CLIENT-ID') 
        os.environ["AZURE_CLIENT_SECRET"] = mssparkutils.credentials.getSecret(key_vault_environment, 'FAB-DBB-DBT-SPN-CLIENT-SECRET')
        os.environ["AZURE_TENANT_ID"] = mssparkutils.credentials.getSecret(key_vault_environment, 'FAB-DBB-DBT-SPN-TENANT-ID') 
        os.environ['FAB_DBB_DBT_ENDPOINT'] = mssparkutils.credentials.getSecret(key_vault_environment, 'FAB-DBB-DBT-ENDPOINT')

        print(f"✅ Successfully retrieved secrets from Key Vault [{environment.upper()}]")
    except Exception as e:
        print(f"❌ Failed to retrieve secrets from Key Vault [{environment.upper()}]: {e}")
        raise

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

### Improve this cell by first identifying the relevant dbt models for the current data product using `dbt ls --select tag:Group-FinancialStatements`, 
### and then check the status only for these specific tables in the monitoring data.

from pyspark.sql import functions as F
from com.microsoft.spark.fabric.Constants import Constants

# Read the monitoring table
df = spark.read.synapsesql("dbb_warehouse.meta.monitoring_integration")

# Filter by the selected data product
df = df.filter(F.col("data_product") == data_product)

# Get the latest orchestration_run_id for this data product
latest_run_id = (
    df.select("orchestration_run_id")
      .distinct()
      .orderBy(F.desc("timestamp"))
      .limit(1)
      .collect()[0][0]
)

# Filter to the latest orchestration run
latest_run_df = df.filter(F.col("orchestration_run_id") == latest_run_id)

# Check if any record in that run failed
failed_tables_df = latest_run_df.filter(F.lower(F.col("status")) == "failed")
failed_count = failed_tables_df.count()

if failed_count > 0:
    print(f"❌ {failed_count} table(s) failed in the latest orchestration run ({latest_run_id}) for '{data_product}'.")
    display(failed_tables_df.select("data_product", "orchestration_run_id", "status", "timestamp"))
    raise Exception(f"Notebook failed: one or more tables failed in the latest orchestration run for '{data_product}'.")
else:
    print(f"✅ All tables succeeded in the latest orchestration run ({latest_run_id}) for '{data_product}'.")

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

# MAGIC %%bash -s {environment} {transformation_timestamp} {models}
# MAGIC 
# MAGIC # Construct monitoring folder for dbt run results
# MAGIC monitoring_folder="../../monitoring/transformation_dbt_$2"
# MAGIC 
# MAGIC 
# MAGIC # Load dependencies and build complete dbt project
# MAGIC cd "/lakehouse/default/Files/transformation/dbt"
# MAGIC dbt deps
# MAGIC dbt build --target "$1" --target-path "$monitoring_folder" --select "$3"

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark",
# META   "frozen": false,
# META   "editable": true
# META }

# CELL ********************

import json
from pyspark.sql import SparkSession
from pyspark.sql.types import StructType, StructField, StringType, IntegerType, FloatType, ArrayType, BooleanType, TimestampType, DoubleType, LongType
from pyspark.sql.functions import explode, col, regexp_extract, to_timestamp, lit


spark = SparkSession.builder.getOrCreate()

# Retrieve workspace ID
workspace_id = notebookutils.runtime.context.get("currentWorkspaceId")

# Retrieve dbt run results and create df structure
# Define file path for run_results
run_results_path = f"/lakehouse/default/Files/monitoring/transformation_dbt_{transformation_timestamp}/run_results.json"

# Load the run_results file
try:
    with open(run_results_path, 'r') as file:
        run_results = json.load(file)
    print("✅ Successfully loaded dbt run results")
except FileNotFoundError:
    print(f"❌ File not found: {run_results_path}")
    raise
except json.JSONDecodeError:
    print(f"❌ Error decoding JSON in file: {run_results_path}")
    raise

# Create the schema for run_results
schema = StructType([
    StructField('status', StringType(), True),
    StructField('timing', ArrayType(
        StructType([
            StructField('name', StringType(), True),
            StructField('started_at', StringType(), True),
            StructField('completed_at', StringType(), True)
        ])
    ), True),
    StructField('thread_id', StringType(), True),
    StructField('execution_time', DoubleType(), True),
    StructField('adapter_response', StructType([
        StructField('_message', StringType(), True),
        StructField('rows_affected', LongType(), True)
    ]), True),
    StructField('message', StringType(), True),
    StructField('failures', StringType(), True),
    StructField('unique_id', StringType(), False),
    StructField('compiled', BooleanType(), True),
    StructField('compiled_code', StringType(), True),
    StructField('relation_name', StringType(), True)
])

df = spark.createDataFrame(run_results['results'], schema)

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark",
# META   "frozen": false,
# META   "editable": true
# META }

# CELL ********************

import com.microsoft.spark.fabric
from com.microsoft.spark.fabric.Constants import Constants
from pyspark.sql.functions import col, explode, regexp_extract, to_timestamp, lit, unix_timestamp, when

# Append dbt run results to monitoring table

df_flat = df.withColumn('timing', explode(col('timing'))) \
            .withColumn('unique_id', regexp_extract(col('unique_id'), r'[^.]+$', 0)) \
            .withColumn('process_started_at', to_timestamp(col('timing.started_at'))) \
            .withColumn('process_completed_at', to_timestamp(col('timing.completed_at'))) \
            .withColumn('duration', (unix_timestamp(col('process_completed_at')) - unix_timestamp(col('process_started_at'))).cast(LongType())) \
            .withColumn('invocation_id', lit(run_results['metadata']['invocation_id'])) \
            .withColumn('generated_at', to_timestamp(lit(run_results['metadata']['generated_at']))) \
            .withColumn('environment', lit(environment.upper())) \
            .withColumn('build_models', lit(models)) \
            .withColumn('orchestration_run_id', when(lit(True), orchestration_run_id).cast(StringType())) \
            .withColumn('data_product', when(lit(True), data_product).cast(StringType())) \
            .withColumn('transformation_pipeline_run_id', when(lit(True), transformation_pipeline_run_id).cast(StringType())) \
            .withColumn('workspace_id', when(lit(True), workspace_id).cast(StringType())) \
            .withColumn('transformation_pipeline_id', when(lit(True), transformation_pipeline_id).cast(StringType()))
            
        
df_flat = df_flat.select(
    col('unique_id').alias('item_name'),
    col('invocation_id'),
    col('status'),
    col('thread_id'),
    col('execution_time'),
    col('failures'),
    col('compiled'),
    col('relation_name'),
    col('adapter_response._message').alias('adapter_message'),
    col('adapter_response.rows_affected').alias('rows_affected'),
    col('timing.name').alias('process_stage'),
    col('process_started_at'),
    col('process_completed_at'),
    col('duration'),
    col('generated_at'),
    col('environment'),
    col('build_models'),
    col('orchestration_run_id'),
    col('data_product'),
    col('transformation_pipeline_run_id'),
    col('workspace_id'),
    col('transformation_pipeline_id')
)

# Write results to Warehouse table
df_flat.write.mode('append').synapsesql("dbb_warehouse.meta.monitoring_transformation_dbt")

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark",
# META   "frozen": false,
# META   "editable": true
# META }
