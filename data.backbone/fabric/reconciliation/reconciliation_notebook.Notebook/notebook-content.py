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
data_product = ""
orchestration_run_id = ""
reconciliation_pipeline_run_id = ""
reconciliation_pipeline_id = ""

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from datetime import datetime
import os

# Generate current UTC timestamp formatted as yyyyMMddHHmmssffffff
reconciliation_timestamp = datetime.utcnow().strftime("%Y%m%d%H%M%S%f")

# Install necessary packages --> handled by dbb custom environment
# !pip install dbt-fabric==1.7.4

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
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

# MAGIC %%bash -s {environment} {reconciliation_timestamp} {reconciliation_pipeline_run_id} {orchestration_run_id} {data_product}
# MAGIC 
# MAGIC # Construct monitoring folder for reconciliation results
# MAGIC monitoring_folder="../../monitoring/reconciliation_dbt_$2"
# MAGIC 
# MAGIC # Go to the dbt project folder
# MAGIC cd "/lakehouse/default/Files/transformation/dbt"
# MAGIC 
# MAGIC # Clean and reinstall dependencies safely
# MAGIC dbt clean
# MAGIC dbt deps
# MAGIC 
# MAGIC # Run the reconciliation model, passing all relevant vars
# MAGIC dbt run \
# MAGIC   --target "$1" \
# MAGIC   --target-path "$monitoring_folder" \
# MAGIC   --select "kpi_reconciliation_history" \
# MAGIC   --vars '{"reconciliation_pipeline_run_id": "'$3'", "orchestration_run_id": "'$4'", "data_product": "'$5'"}'

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from pyspark.sql import functions as F
from com.microsoft.spark.fabric.Constants import Constants

# Read the monitoring table
df = spark.read.synapsesql("dbb_warehouse.data_mon.kpi_reconciliation_history")

# (Optional) Filter to current job run
df = df.filter(F.col("reconciliation_pipeline_run_id") == reconciliation_pipeline_run_id)

# Group by KPI and job to compare source amounts
diff_df = (
    df.groupBy("kpi_name", "reconciliation_pipeline_run_id")
      .agg(
          F.max("amount").alias("max_amount"),
          F.min("amount").alias("min_amount")
      )
      .withColumn("difference", F.col("max_amount") - F.col("min_amount"))
      .filter(F.col("max_amount") != F.col("min_amount"))
)

# Count mismatches
mismatch_count = diff_df.count()

if mismatch_count > 0:
    print("❌ Reconciliation check failed!")
    display(diff_df)

    ### Uncomment next line to let notebook fail when Reconciliation Checks did not pass
    # raise Exception(f"Data mismatch detected in {mismatch_count} KPI(s). Notebook will fail.")
else:
    print("✅ Reconciliation check passed successfully.")

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
