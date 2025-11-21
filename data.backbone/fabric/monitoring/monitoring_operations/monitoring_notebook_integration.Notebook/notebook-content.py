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

# These parameters will be replaced at runtime.

table_name = "test_table"
schema_name = "test_schema"
source_name = "test_source"
source_type = "SQL"
load_type = "FULL"
workspace = "913a2dc2-5f68-4fb7-ab07-631a84561fd6"
status = "Success"
duration = "0"  # seconds
throughput = "0.00"
data_read = "0"
data_written = "0"
rows_read = "0"
rows_written = "0"
ingestion_timestamp = "2024-03-27 00:00:00.000000"

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "jupyter_python"
# META }

# CELL ********************

import pyarrow as pa
from datetime import datetime

# Convert types
duration = int(duration)
throughput = float(throughput)
data_read = int(data_read)
data_written = int(data_written)
rows_read = int(rows_read)
rows_written = int(rows_written)

# Function to format timestamp for T-SQL DATETIME2(6) as a string
monitoring_timestamp = datetime.strptime(ingestion_timestamp, "%Y-%m-%d %H:%M:%S.%f")

conn = notebookutils.data.connect_to_artifact("dbb_warehouse", workspace, "Warehouse")
sql = """
INSERT INTO [meta].[monitoring_integration] (
	[table_name],
	[schema_name],
	[source_name],
	[source_type],
	[load_type],
	[workspace],
	[status],
	[timestamp],
	[duration],
	[throughput],
	[data_read],
	[data_written],
	[rows_read],
	[rows_written]
	)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
"""
try:
	cursor = conn.execute(sql,table_name, schema_name, source_name, source_type, load_type, workspace, status, monitoring_timestamp,duration, float(throughput), data_read,
						data_written, rows_read, rows_written)
	conn.commit()
	conn.close()	
	print(f"✅ Successfully logged monitoring info for {table_name}")
except Exception as e:
    print(f"❌ Failed to log monitoring info for {table_name}. Error: {str(e)}")

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "jupyter_python"
# META }
