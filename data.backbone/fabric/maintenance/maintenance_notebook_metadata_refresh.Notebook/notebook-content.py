# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "jupyter",
# META     "jupyter_kernel_name": "python3.11"
# META   },
# META   "dependencies": {}
# META }

# PARAMETERS CELL ********************

# Add required parameters to run metadata refresh on Fabric artifact

workspace_id = "913a2dc2-5f68-4fb7-ab07-631a84561fd6"
artifact_id = "a3c7dd8f-25f9-4aa9-aaad-981087e7d0d4"
environment = "TST"

# Possiblities are "lakehouses" or "warehouses"
artifact_type = "lakehouses" 

lakehouse_name = "dbb_lakehouse"
warehouse_name = "dbb_warehouse"

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "jupyter_python"
# META }

# CELL ********************

import json
import time
import struct
import sqlalchemy
import pyodbc
import notebookutils
import pandas as pd
from pyspark.sql import functions as fn
from datetime import datetime
import sempy.fabric as fabric
from sempy.fabric.exceptions import FabricHTTPException, WorkspaceNotFoundException
import pyarrow as pa
from IPython.display import display

# Install required packages
!pip install semantic-link --q

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "jupyter_python"
# META }

# CELL ********************

# First we trigger a wake-up on each table in the dbo schema of the Lakehouse

# Connect to Lakehouse
lakehouse_conn = notebookutils.data.connect_to_artifact(lakehouse_name, workspace_id, "Lakehouse")

# Get list of all tables in the dbo schema
tables_df = lakehouse_conn.execute("""
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'dbo'
""").fetchall()

# Loop through each table and perform SELECT TOP 1 *
for row in tables_df:
    table = row[0]
    try:
        df = pd.read_sql(f"SELECT TOP 1 * FROM [dbo].[{table}]", lakehouse_conn)
    except Exception as e:
        print(f"Error querying table {table}: {e}")


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "jupyter_python"
# META }

# CELL ********************

# Ensures consistent string width for aligned console output (truncates or pads as needed)
def pad_or_truncate_string(input_string, length, pad_char=' '):
    # Truncate if the string is longer than the specified length
    if len(input_string) > length:
        return input_string[:length]
    # Pad if the string is shorter than the specified length
    return input_string.ljust(length, pad_char)

#Instantiate the client
client = fabric.FabricRestClient()

# Check artifact_type to determine right sqlendpoint to refresh
if artifact_type == 'lakehouses':
    endpoint_id = fabric.FabricRestClient().get(f"/v1/workspaces/{workspace_id}/{artifact_type}/{artifact_id}").json()['properties']['sqlEndpointProperties']['id']
    payload = {"commands":[{"$type":"MetadataRefreshExternalCommand"}]}
    uri_type = 'lhdatamarts'
elif artifact_type == 'warehouses':
    endpoint_id = artifact_id
    payload = {"commands":[{"$type":"MetadataRefreshCommand"}]}
    uri_type = 'datawarehouses'
else:
    raise Exception('Invalid artifact_type')

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "jupyter_python"
# META }

# CELL ********************

# Now we perform the (unofficial) metadata refresh using the Fabric API

# URI for the call
uri = f"/v1.0/myorg/{uri_type}/{endpoint_id}"

# Call the REST API
response = client.post(uri,json=payload)
## You should add some error handling here

# return the response from json into an object we can get values from
data = json.loads(response.text)

# We just need this, we pass this to call to check the status
batchId = data["batchId"]

# the state of the sync i.e. inProgress
progressState = data["progressState"]

# URL so we can get the status of the sync
statusuri = f"/v1.0/myorg/{uri_type}/{endpoint_id}/batches/{batchId}"

statusresponsedata = ""

while progressState == 'inProgress' :
    # For the demo, I have removed the 1 second sleep.
    time.sleep(1)

    # check to see if its sync'ed
    #statusresponse = client.get(statusuri)

    # turn response into object
    statusresponsedata = client.get(statusuri).json()

    # get the status of the check
    progressState = statusresponsedata["progressState"]
    # show the status
    display(f"Sync state: {progressState}")

# if its good, then create a temp results, with just the info we care about
if progressState == 'success':
    table_details = [
        {
          'tableName': table['tableName'],
         'warningMessages': table.get('warningMessages', []),
         'lastSuccessfulUpdate': table.get('lastSuccessfulUpdate', 'N/A'),
         'tableSyncState':  table['tableSyncState'],
         'sqlSyncState':  table['sqlSyncState']
        }
        for table in statusresponsedata['operationInformation'][0]['progressDetail']['tablesSyncStatus']
    ]

# if its good, then shows the tables
if progressState == 'success':
    # Print the extracted details
    print("Extracted Table Details:")
    for detail in table_details:
        print(f"Table: {pad_or_truncate_string(detail['tableName'],30)}   Last Update: {detail['lastSuccessfulUpdate']}  tableSyncState: {detail['tableSyncState']}   Warnings: {detail['warningMessages']}")

## if there is a problem, show all the errors
if progressState == 'failure':
    # display error if there is an error
    display(statusresponsedata)

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "jupyter_python"
# META }
