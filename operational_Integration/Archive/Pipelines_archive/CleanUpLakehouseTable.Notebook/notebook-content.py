# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {
# META     "lakehouse": {
# META       "default_lakehouse": "5a33d451-347a-40ac-992d-029395af1c55",
# META       "default_lakehouse_name": "dbb_lakehouse_DIH",
# META       "default_lakehouse_workspace_id": "5c450b57-bfb8-4fc6-b34c-e6fe494e12c1"
# META     }
# META   }
# META }

# PARAMETERS CELL ********************

tableName = ""

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

print("Dropping following table from dbb_lakehouse_DIH: {tableName}")

spark.sql(f"DROP TABLE IF EXISTS {tableName}")

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
