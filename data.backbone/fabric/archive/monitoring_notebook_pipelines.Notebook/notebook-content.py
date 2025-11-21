# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "jupyter",
# META     "jupyter_kernel_name": "python3.11"
# META   },
# META   "dependencies": {}
# META }

# CELL ********************

import requests
import pandas as pd
import time
from datetime import datetime, timedelta
import sempy.fabric as fabric

# === CONFIGURATION ===
workspace_id = fabric.get_notebook_workspace_id()
access_token = notebookutils.credentials.getToken('pbi')
base_url = "https://api.fabric.microsoft.com/v1/workspaces"
headers = {"Authorization": f"Bearer {access_token}"}

# === HELPER: API Call with Retry and Backoff ===
def safe_get(url, retries=8, backoff_factor=3, delay_between_requests=1):
    for attempt in range(retries):
        response = requests.get(url, headers=headers)
        if response.status_code == 429:
            wait_time = backoff_factor ** attempt
            print(f"⚠️ Rate limit hit. Retrying in {wait_time} seconds...")
            time.sleep(wait_time)
            continue
        response.raise_for_status()
        time.sleep(delay_between_requests)
        return response
    raise Exception(f"Failed after {retries} retries due to rate limiting: {url}")

# === STEP 1: Get all pipeline items in the workspace ===
def get_pipelines():
    url = f"{base_url}/{workspace_id}/items"
    response = safe_get(url)
    items = response.json().get("value", [])
    pipelines = [i for i in items if i["type"] == "DataPipeline"]

    print("\n======================================")
    print("📊  Data Pipelines in Workspace")
    print("======================================\n")

    if not pipelines:
        print("No data pipelines found.")
    else:
        df = pd.DataFrame(pipelines)[["displayName", "id", "folderId"]]
        df.index = df.index + 1
        print(df.to_string(index=True))
    return pipelines

# === STEP 2: Get job instances from the last 24 hours for a given pipeline ===
def get_pipeline_job_instances(item_id):
    last_24h = datetime.utcnow() - timedelta(days=1)
    last_24h_iso = last_24h.isoformat() + "Z"
    url = f"{base_url}/{workspace_id}/items/{item_id}/jobs/instances?startTime={last_24h_iso}"
    response = safe_get(url)
    return response.json().get("value", [])

# === STEP 3: Get detailed metadata for a single job instance ===
def get_job_instance_detail(item_id, job_instance_id):
    url = f"{base_url}/{workspace_id}/items/{item_id}/jobs/instances/{job_instance_id}"
    response = safe_get(url)
    return response.json()

# === STEP 4: Collect metadata for all pipelines and recent job instances ===
metadata_records = []

for pipeline in get_pipelines():
    item_id = pipeline["id"]
    job_instances = get_pipeline_job_instances(item_id)
    print(f"\n📂 Processing pipeline: {pipeline['displayName']} ({len(job_instances)} jobs in last 24h)")

    for job in job_instances:
        try:
            job_detail = get_job_instance_detail(item_id, job["id"])
            metadata_records.append({
                "pipeline_name": pipeline["displayName"],
                "pipeline_id": item_id,
                "job_instance_id": job_detail["id"],
                "status": job_detail.get("status"),
                "invoke_type": job_detail.get("invokeType"),
                "job_type": job_detail.get("jobType"),
                "root_activity_id": job_detail.get("rootActivityId"),
                "start_time_utc": job_detail.get("startTimeUtc"),
                "end_time_utc": job_detail.get("endTimeUtc"),
                "failure_reason": job_detail.get("failureReason"),
            })
        except requests.exceptions.HTTPError as e:
            print(f"❌ Failed to fetch job detail for {job['id']}: {e}")

# === STEP 5: Convert to DataFrame ===
df_metadata = pd.DataFrame(metadata_records)
display(df_metadata.head())

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "jupyter_python",
# META   "frozen": true,
# META   "editable": false
# META }

# CELL ********************

display(df_metadata.head(1000))

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "jupyter_python",
# META   "frozen": true,
# META   "editable": false
# META }

# CELL ********************

import json
from datetime import datetime

# Connect to Fabric Warehouse
conn = notebookutils.data.connect_to_artifact(
    "dbb_warehouse",
    workspace_id,
    "Warehouse"
)

try:
    # Ensure the schema and table exist
    create_table_sql = """
    IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'meta')
        EXEC('CREATE SCHEMA meta');

    IF OBJECT_ID('meta.monitoring_pipeline_runs', 'U') IS NULL
    BEGIN
        CREATE TABLE meta.monitoring_pipeline_runs (
            pipeline_name VARCHAR(255),
            pipeline_id VARCHAR(100),
            job_instance_id VARCHAR(100),
            status VARCHAR(50),
            invoke_type VARCHAR(100),
            job_type VARCHAR(100),
            root_activity_id VARCHAR(100),
            start_time_utc DATETIME2(3),
            end_time_utc DATETIME2(3),
            failure_reason VARCHAR(MAX),
            load_timestamp DATETIME2(3),
            workspace_id VARCHAR(100)
        );
    END
    """
    conn.execute(create_table_sql)
    conn.commit()
    print("✅ Table 'meta.monitoring_pipeline_runs' is ready.")

    # Truncate table to overwrite existing data
    conn.execute("TRUNCATE TABLE meta.monitoring_pipeline_runs")
    conn.commit()
    print("✅ Table truncated, ready for new data.")

    # Insert rows
    insert_sql = """
    INSERT INTO [meta].[monitoring_pipeline_runs] (
        pipeline_name,
        pipeline_id,
        job_instance_id,
        status,
        invoke_type,
        job_type,
        root_activity_id,
        start_time_utc,
        end_time_utc,
        failure_reason,
        load_timestamp,
        workspace_id
    )
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """

    inserted_rows = 0
    now = datetime.utcnow()
    for _, row in df_metadata.iterrows():
        # Convert dict/list to string if needed
        failure_reason_str = json.dumps(row['failure_reason']) if isinstance(row['failure_reason'], (dict, list)) else str(row['failure_reason']) if row['failure_reason'] is not None else None

        conn.execute(insert_sql,
            str(row.get('pipeline_name')),
            str(row.get('pipeline_id')),
            str(row.get('job_instance_id')),
            str(row.get('status')) if row.get('status') is not None else None,
            str(row.get('invoke_type')) if row.get('invoke_type') is not None else None,
            str(row.get('job_type')) if row.get('job_type') is not None else None,
            str(row.get('root_activity_id')) if row.get('root_activity_id') is not None else None,
            row.get('start_time_utc'),
            row.get('end_time_utc'),
            failure_reason_str,
            now,
            workspace_id
        )
        inserted_rows += 1

    conn.commit()
    print(f"✅ Successfully overwritten {inserted_rows} rows in [meta].[monitoring_pipeline_runs].")

except Exception as e:
    print(f"❌ Failed to insert data. Error: {str(e)}")

finally:
    conn.close()
    print("🔒 Connection closed.")


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "jupyter_python",
# META   "frozen": true,
# META   "editable": false
# META }

# CELL ********************

import requests
import pandas as pd
import time
from datetime import datetime, timedelta
import sempy.fabric as fabric
from concurrent.futures import ThreadPoolExecutor
import json

# === CONFIGURATION ===
workspace_id = fabric.get_notebook_workspace_id()
access_token = notebookutils.credentials.getToken('pbi')
base_url = "https://api.fabric.microsoft.com/v1/workspaces"
headers = {"Authorization": f"Bearer {access_token}"}

# === CONNECT TO FABRIC WAREHOUSE ===
conn = notebookutils.data.connect_to_artifact("dbb_warehouse", workspace_id, "Warehouse")

# === STEP 0: Ensure table exists ===
table_check_sql = """
-- Main table
IF OBJECT_ID('meta.monitoring_pipeline_runs', 'U') IS NULL
BEGIN
    CREATE TABLE meta.monitoring_pipeline_runs (
        pipeline_name VARCHAR(255) COLLATE Latin1_General_100_BIN2_UTF8,
        pipeline_id VARCHAR(100) COLLATE Latin1_General_100_BIN2_UTF8,
        job_instance_id VARCHAR(100) COLLATE Latin1_General_100_BIN2_UTF8,
        status VARCHAR(50) COLLATE Latin1_General_100_BIN2_UTF8,
        invoke_type VARCHAR(100) COLLATE Latin1_General_100_BIN2_UTF8,
        job_type VARCHAR(100) COLLATE Latin1_General_100_BIN2_UTF8,
        root_activity_id VARCHAR(100) COLLATE Latin1_General_100_BIN2_UTF8,
        start_time_utc DATETIME2(3),
        end_time_utc DATETIME2(3),
        failure_reason VARCHAR(MAX) COLLATE Latin1_General_100_BIN2_UTF8,
        load_timestamp DATETIME2(3),
        workspace_id VARCHAR(100) COLLATE Latin1_General_100_BIN2_UTF8
    );
END
"""

conn.execute(table_check_sql)
conn.commit()
print("✅ Table 'meta.monitoring_pipeline_runs' is ready or already exists.")

# Fetch latest start_time_utc for incremental load
result = conn.execute("SELECT ISNULL(MAX(start_time_utc), '1900-01-01') FROM meta.monitoring_pipeline_runs")
latest_start_time_utc = result.fetchone()[0]
print(f"🕒 Latest recorded start_time_utc: {latest_start_time_utc}")

# === HELPER: API Call with Retry & Backoff ===
def safe_get(url, retries=8, backoff_factor=3, delay_between_requests=1):
    for attempt in range(retries):
        response = requests.get(url, headers=headers)
        if response.status_code == 429:
            wait_time = backoff_factor ** attempt
            print(f"⚠️ Rate limit hit. Retrying in {wait_time} seconds...")
            time.sleep(wait_time)
            continue
        response.raise_for_status()
        time.sleep(delay_between_requests)
        return response
    raise Exception(f"Failed after {retries} retries due to rate limiting: {url}")

# === STEP 1: Get pipelines ===
def get_pipelines():
    url = f"{base_url}/{workspace_id}/items"
    response = safe_get(url)
    items = response.json().get("value", [])
    pipelines = [i for i in items if i["type"] == "DataPipeline"]
    return pipelines

pipelines = get_pipelines()
print(f"📊 Found {len(pipelines)} pipelines in workspace")

# === STEP 2: Incremental fetch of job instances ===
# Overlap window of 1 hour for updates
fetch_from = latest_start_time_utc - timedelta(hours=1)
fetch_from_iso = fetch_from.isoformat() + "Z"

# Load existing job_instance_ids to skip duplicates
existing_jobs = set(r[0] for r in conn.execute("SELECT job_instance_id FROM meta.monitoring_pipeline_runs").fetchall())

def fetch_pipeline_jobs(pipeline):
    item_id = pipeline["id"]
    url = f"{base_url}/{workspace_id}/items/{item_id}/jobs/instances?startTime={fetch_from_iso}&status=Running,Succeeded,Failed"
    jobs = safe_get(url).json().get("value", [])
    new_jobs = [j for j in jobs if j["id"] not in existing_jobs]
    return pipeline, new_jobs

with ThreadPoolExecutor(max_workers=5) as executor:
    results = list(executor.map(fetch_pipeline_jobs, pipelines))

# === STEP 3: Fetch detailed job metadata ===
metadata_records = []
for pipeline, job_instances in results:
    print(f"\n📂 Pipeline: {pipeline['displayName']} ({len(job_instances)} new/updated jobs)")
    for job in job_instances:
        try:
            job_detail = safe_get(f"{base_url}/{workspace_id}/items/{pipeline['id']}/jobs/instances/{job['id']}").json()
            metadata_records.append({
                "pipeline_name": pipeline["displayName"],
                "pipeline_id": pipeline["id"],
                "job_instance_id": job_detail["id"],
                "status": job_detail.get("status"),
                "invoke_type": job_detail.get("invokeType"),
                "job_type": job_detail.get("jobType"),
                "root_activity_id": job_detail.get("rootActivityId"),
                "start_time_utc": job_detail.get("startTimeUtc"),
                "end_time_utc": job_detail.get("endTimeUtc"),
                "failure_reason": json.dumps(job_detail.get("failureReason")) if isinstance(job_detail.get("failureReason"), (dict, list)) else str(job_detail.get("failureReason")) if job_detail.get("failureReason") else None,
                "load_timestamp": datetime.utcnow(),
                "workspace_id": workspace_id
            })
        except requests.exceptions.HTTPError as e:
            print(f"❌ Failed to fetch job detail for {job['id']}: {e}")

df_metadata = pd.DataFrame(metadata_records)

display(df_metadata)

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "jupyter_python",
# META   "frozen": false,
# META   "editable": true
# META }

# CELL ********************

if not df_metadata.empty:
    
    staging_table_check_sql = """
    -- Staging table
    IF OBJECT_ID('meta.staging_pipeline_runs', 'U') IS NULL
    BEGIN
        CREATE TABLE meta.staging_pipeline_runs (
            pipeline_name VARCHAR(255) COLLATE Latin1_General_100_BIN2_UTF8,
            pipeline_id VARCHAR(100) COLLATE Latin1_General_100_BIN2_UTF8,
            job_instance_id VARCHAR(100) COLLATE Latin1_General_100_BIN2_UTF8,
            status VARCHAR(50) COLLATE Latin1_General_100_BIN2_UTF8,
            invoke_type VARCHAR(100) COLLATE Latin1_General_100_BIN2_UTF8,
            job_type VARCHAR(100) COLLATE Latin1_General_100_BIN2_UTF8,
            root_activity_id VARCHAR(100) COLLATE Latin1_General_100_BIN2_UTF8,
            start_time_utc DATETIME2(3),
            end_time_utc DATETIME2(3),
            failure_reason VARCHAR(MAX) COLLATE Latin1_General_100_BIN2_UTF8,
            load_timestamp DATETIME2(3),
            workspace_id VARCHAR(100) COLLATE Latin1_General_100_BIN2_UTF8
        );
    END
    """

    conn.execute(staging_table_check_sql)
    conn.execute("TRUNCATE TABLE meta.staging_pipeline_runs")
    conn.commit()

    insert_sql = """
    INSERT INTO meta.staging_pipeline_runs (
        pipeline_name, pipeline_id, job_instance_id, status, invoke_type,
        job_type, root_activity_id, start_time_utc, end_time_utc,
        failure_reason, load_timestamp, workspace_id
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """
    for _, row in df_metadata.iterrows():
        conn.execute(insert_sql,
                     row.pipeline_name,
                     row.pipeline_id,
                     row.job_instance_id,
                     row.status,
                     row.invoke_type,
                     row.job_type,
                     row.root_activity_id,
                     row.start_time_utc,
                     row.end_time_utc,
                     row.failure_reason,
                     row.load_timestamp,
                     row.workspace_id)
    conn.commit()
    print(f"✅ Inserted {len(df_metadata)} rows into staging table.")

    # === STEP 5: UPSERT from staging to main table ===
    # Insert new rows
    upsert_insert_sql = """
    INSERT INTO meta.monitoring_pipeline_runs (
        pipeline_name, pipeline_id, job_instance_id, status, invoke_type,
        job_type, root_activity_id, start_time_utc, end_time_utc,
        failure_reason, load_timestamp, workspace_id
    )
    SELECT s.pipeline_name, s.pipeline_id, s.job_instance_id, s.status, s.invoke_type,
           s.job_type, s.root_activity_id, s.start_time_utc, s.end_time_utc,
           s.failure_reason, s.load_timestamp, s.workspace_id
    FROM meta.staging_pipeline_runs s
    LEFT JOIN meta.monitoring_pipeline_runs t
           ON t.job_instance_id = s.job_instance_id
    WHERE t.job_instance_id IS NULL
    """
    conn.execute(upsert_insert_sql)
    conn.commit()

    # Update existing rows
    upsert_update_sql = """
    UPDATE t
    SET t.status = s.status,
        t.invoke_type = s.invoke_type,
        t.job_type = s.job_type,
        t.root_activity_id = s.root_activity_id,
        t.start_time_utc = s.start_time_utc,
        t.end_time_utc = s.end_time_utc,
        t.failure_reason = s.failure_reason,
        t.load_timestamp = s.load_timestamp,
        t.workspace_id = s.workspace_id
    FROM meta.monitoring_pipeline_runs t
    INNER JOIN meta.staging_pipeline_runs s
        ON t.job_instance_id = s.job_instance_id
    """
    conn.execute(upsert_update_sql)
    conn.commit()
    print("✅ UPSERT completed from staging to main table.")

conn.close()
print("🔒 Connection closed.")

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "jupyter_python"
# META }
