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

# This notebook will append transformation load monitoring data to the Data BackBone
# Please refer to documentation for full field descriptions and parameter expectations

workspace = "913a2dc2-5f68-4fb7-ab07-631a84561fd6"
status = "Success"
duration = "0"  # in seconds
pool_id = "test_pool"
session_id = "test_session"
run_id = "test_run"
message = "Test completed successfully"

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "jupyter_python"
# META }

# CELL ********************

import pyarrow as pa
from datetime import datetime

# Convert types
monitoring_timestamp = datetime.utcnow()
duration = int(duration)

# Optional: sanitize or cast string inputs
workspace = str(workspace)
status = str(status)
pool_id = str(pool_id)
session_id = str(session_id)
run_id = str(run_id)
message = str(message)

# Connect to Fabric Warehouse
conn = notebookutils.data.connect_to_artifact(
    "dbb_warehouse",  # Logical name of the warehouse
    workspace,  # Workspace ID
    "Warehouse"
)

# Prepare SQL for insert
sql = """
INSERT INTO [meta].[monitoring_transformation] (
    [workspace],
    [status],
    [timestamp],
    [duration],
    [pool_id],
    [session_id],
    [run_id],
    [message]
)
VALUES (?, ?, ?, ?, ?, ?, ?, ?)
"""

# Execute insert
try:
    cursor = conn.execute(sql,
        workspace,
        status,
        monitoring_timestamp,
        duration,
        pool_id,
        session_id,
        run_id,
        message
    )
    conn.commit()
    conn.close()
    print("\u2705 Successfully logged transformation monitoring info")
except Exception as e:
    print(f"\u274C Failed to log transformation monitoring info. Error: {str(e)}")

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "jupyter_python"
# META }
