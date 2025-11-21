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

table_identifier = ["Anaplan__dbo_Anaplan_Budget"]
validation_timestamp = "20250702000000000000"

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

try:
    print(f"✅ Empty check van tabel: {table_identifier}")

    # Selecteer eerste 10 rijen van Delta-tabel uit Lakehouse
    df_sample = spark.sql(f"SELECT * FROM `{table_identifier}` LIMIT 10")

    output_path = f"Files/monitoring/integration_validation/validation_notebook_empty_check_{table_identifier}_{validation_timestamp}"

    # Schrijf weg als CSV met header
    df_sample.coalesce(1).write.mode("overwrite").option("header", True).csv(output_path)

    print(f"📁 CSV opgeslagen op: {output_path}")

except Exception as e:
    print(f"❌ Fout bij het verwerken van {table_identifier}: {str(e)}")


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
