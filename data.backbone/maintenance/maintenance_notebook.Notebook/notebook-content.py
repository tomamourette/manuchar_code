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
# META     "warehouse": {}
# META   }
# META }

# PARAMETERS CELL ********************

# This maintenance notebook will run Delta maintenance on all required Delta tables in the Data BackBone
# Please refer to documentation on more thorough information on what processes are included

environment = "tst"

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from datetime import datetime
import time
from delta.tables import DeltaTable
from pyspark.sql import SparkSession
import com.microsoft.spark.fabric
from com.microsoft.spark.fabric.Constants import Constants
import pandas as pd
from pyspark.sql.types import StructType, StructField, StringType, FloatType, DoubleType

# Function to format timestamp for T-SQL DATETIME2(6) as a string
def get_current_timestamp():
    return datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S.%f")

# Function to truncate strings to a max length (e.g., VARCHAR(5000) for error logs)
def truncate_string(value, max_length=5000):
    if value is None:
        return None
    return str(value)[:max_length]

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

########
# Perform maintenance on all permanent tables in the Lakehouse
########

spark = SparkSession.builder.getOrCreate()

# Get all tables in the Lakehouse
tables_df = spark.sql("SHOW TABLES").toPandas()
tables_df['full_table_name'] = tables_df['namespace'] + "." + tables_df['tableName']
print(f"✅ Found {len(tables_df)} tables in Lakehouse")

log_entries = []
result_rows = []

# Loop through all tables
for _, row in tables_df.iterrows():
    table_name_sql = row['full_table_name']
    table_name = row['tableName']
    schema_name = row['namespace']
    source = "unknown"

    print(f"\n🚀 Starting OPTIMIZE for table: {table_name_sql}")

    optimize_duration = 0
    vacuum_duration = 0
    optimize_status = "Failure"
    vacuum_status = "Skipped"
    optimize_error_log = None
    vacuum_error_log = None

    # Perform OPTIMIZE
    try:
        start_time = time.time()
        spark.sql(f"OPTIMIZE {table_name_sql}")
        optimize_duration = round(time.time() - start_time, 2)
        optimize_status = "Success"
        print(f"✅ OPTIMIZE successful for {table_name_sql} in {optimize_duration} seconds")
    except Exception as e:
        optimize_error_log = str(e)
        print(f"❌ OPTIMIZE failed for {table_name_sql}: {optimize_error_log}")

    # Perform VACUUM only if OPTIMIZE was successful
    if optimize_status == "Success":
        print(f"🔁 Starting VACUUM for table: {table_name_sql}")
        try:
            start_time = time.time()
            DeltaTable.forName(spark, table_name_sql).vacuum(168)
            vacuum_duration = round(time.time() - start_time, 2)
            vacuum_status = "Success"
            print(f"✅ VACUUM successful for {table_name_sql} in {vacuum_duration} seconds")
        except Exception as e:
            vacuum_status = "Failure"
            vacuum_error_log = str(e)
            print(f"❌ VACUUM failed for {table_name_sql}: {vacuum_error_log}")
    else:
        print(f"⏭️ VACUUM skipped for {table_name_sql} due to failed OPTIMIZE")

    # Append to results table
    result_rows.append({
        "table_name": table_name,
        "schema_name": schema_name,
        "source_name": source,
        "optimize_status": optimize_status,
        "optimize_duration_sec": optimize_duration,
        "optimize_error": truncate_string(optimize_error_log),
        "vacuum_status": vacuum_status,
        "vacuum_duration_sec": vacuum_duration,
        "vacuum_error": truncate_string(vacuum_error_log)
    })

    log_entries.append((table_name, schema_name, source, environment.upper(), optimize_status, "OPTIMIZE", float(optimize_duration), get_current_timestamp()))
    if vacuum_status in ["Success", "Failure"]:
        log_entries.append((table_name, schema_name, source, environment.upper(), vacuum_status, "VACUUM", float(vacuum_duration), get_current_timestamp()))

# Write logs to monitoring table
if log_entries:
    schema = StructType([
        StructField("table_name", StringType(), False),
        StructField("schema_name", StringType(), False),
        StructField("source_name", StringType(), False),
        StructField("environment", StringType(), False),
        StructField("status", StringType(), False),
        StructField("maintenance_type", StringType(), False),
        StructField("duration", DoubleType(), False),
        StructField("maintenance_timestamp", StringType(), False)
    ])

    log_df = spark.createDataFrame(log_entries, schema=schema)

    try:
        log_df.write.mode("append").synapsesql("dbb_warehouse.meta.monitoring_maintenance")
        print("\n✅ Successfully wrote batch log to monitoring table.")
    except Exception as e:
        print(f"\n❌ Failed to write batch log: {str(e)}")

# Display results summary
results_df = pd.DataFrame(result_rows)
results_df

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
