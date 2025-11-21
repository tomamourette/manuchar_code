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

# Define workspace and artifact names
workspace = "913a2dc2-5f68-4fb7-ab07-631a84561fd6"

lakehouse_name = "dbb_lakehouse"
warehouse_name = "dbb_warehouse"
ingestion_timestamp = "2025-07-02 00:00:00.000000"

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

# Imports, Spark Session, and Rollback Function definition
from datetime import datetime
import pandas as pd
from pyspark.sql import SparkSession
from delta.tables import DeltaTable

spark = SparkSession.builder.getOrCreate()

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from datetime import datetime
import pandas as pd

# List Tables, Check Row Counts
now = datetime.utcnow()
summary_data = []

# Get all permanent tables
tables_df = spark.sql("SHOW TABLES").toPandas()
print(f"✅ Found {len(tables_df)} tables in Lakehouse")

for _, row in tables_df.iterrows():
    table_name = row["tableName"]

    # Init defaults
    source_name = "unknown"
    schema_name = "unknown"
    pure_table_name = "unknown"

    # Extract source_name, schema_name, and table_name
    if "__" in table_name:
        source_name, schema_table_name = table_name.split("__", 1)
        if "_" in schema_table_name:
            schema_name, pure_table_name = schema_table_name.split("_", 1)
        else:
            schema_name = schema_table_name
            pure_table_name = "unknown"
    else:
        schema_table_name = table_name

    try:
        result = spark.sql(
            f"""
            SELECT COUNT(*) AS row_count
            FROM `{table_name}`
            """
        ).collect()[0]

        row_count = result["row_count"]
        summary_data.append({
            "table_identifier": table_name,
            "source_name": source_name,
            "schema_table_name": schema_table_name,
            "schema_name": schema_name,
            "table_name": pure_table_name,
            "row_count": row_count,
            "method": "pyspark"
        })

    except Exception as e:
        summary_data.append({
            "table_identifier": table_name,
            "source_name": source_name,
            "schema_table_name": schema_table_name,
            "schema_name": schema_name,
            "table_name": pure_table_name,
            "row_count": -1,
            "method": "pyspark",
            "error": str(e)
        })

# Show results
summary_df = pd.DataFrame(summary_data)
display(summary_df)


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from pyspark.sql.types import StructType, StructField, StringType, LongType, TimestampType

# Define schema to write
schema = StructType([
    StructField("table_identifier", StringType(), True),
    StructField("source_name", StringType(), True),
    StructField("schema_table_name", StringType(), True),       
    StructField("workspace", StringType(), True),
    StructField("row_count", LongType(), True),
    StructField("latest_ingestion_timestamp", TimestampType(), True),
    StructField("timestamp", TimestampType(), True)
])


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from pyspark.sql.functions import lit, to_timestamp
from com.microsoft.spark.fabric.Constants import Constants

# Convert to Spark DataFrame with initial schema inference
df_temp = spark.createDataFrame(summary_data)

# Add workspace and timestamp columns, and cast for compatibility
df_spark = df_temp.withColumn("workspace", lit(workspace).cast(StringType())) \
                  .withColumn("timestamp", to_timestamp(lit(ingestion_timestamp)).cast(TimestampType())) \
                  .withColumn("latest_ingestion_timestamp", lit(None).cast(TimestampType()))

# Select and reorder columns to match Warehouse table
df_spark = df_spark.select(
    "table_identifier",
    "source_name",
    "schema_table_name",
    "workspace",
    "row_count",
    "latest_ingestion_timestamp",
    "timestamp"
)

# Apply schema strictly to enforce type and nullability
df_final = spark.createDataFrame(df_spark.rdd, schema)

try:
    df_final.write.mode("append").synapsesql("dbb_warehouse.meta.monitoring_integration_validation")
    print("✅ Successfully logged validation info to Warehouse via synapsesql.")
except Exception as e:
    print(f"❌ Failed to log validation info. Error: {str(e)}")


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

import json
import requests

# Webhook URL
teams_webhook_url = "https://manuchar.webhook.office.com/webhookb2/acfb120c-ba5e-47b2-9b68-ae8ad8057fcc@1da4383b-8064-4d80-ad26-7ee24a0ac477/IncomingWebhook/3e970bf5139e4b44b45ba0956f4994aa/c258282e-0d54-4684-bfc2-cbf14709d3d7/V2A97rhAubV3IaM9l9sp-QKFmuRrWckwlnPJHZAZMsdv01"

# Alert on empty tables (row_count = 0)
empty_tables = [row for row in summary_data if row.get("row_count", 0) == 0]

if empty_tables:
    message_lines = [
        f"- `{row['table_identifier']}` (source: {row['source_name']}, method: {row['method']})"
        for row in empty_tables
    ]
    message = {
        "@type": "MessageCard",
        "@context": "http://schema.org/extensions",
        "summary": "Lakehouse Table Validation",
        "themeColor": "FF0000",
        "title": f"⚠️ {len(empty_tables)} table(s) in Lakehouse have 0 rows",
        "text": f"Workspace: **{workspace}**\n\n" + "\n".join(message_lines)
    }

    try:
        response = requests.post(teams_webhook_url, headers={"Content-Type": "application/json"}, data=json.dumps(message))
        if response.status_code == 200:
            print("✅ Teams notification sent.")
        else:
            print(f"❌ Failed to send Teams notification: {response.status_code} - {response.text}")
    except Exception as e:
        print(f"❌ Exception while sending Teams notification: {str(e)}")


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
