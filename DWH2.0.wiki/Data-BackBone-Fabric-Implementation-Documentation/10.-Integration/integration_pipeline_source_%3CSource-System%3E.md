# integration_pipeline_source_<Source System> – DBB Source System Ingestion

[[_TOC_]]

## Overview

The `integration_pipeline_source_<Source System>` is a **metadata-driven ingestion pipeline** in the Data BackBone (DBB) platform.  
It is responsible for retrieving data from a specific physical source system and loading it into the DBB integration layer (`dbb_lakehouse`).  

Each source system (e.g. *Mona*, *MDS*, *Dynamics*, *GenericData*, *Boomi*) has its own dedicated integration pipeline with the same standardized structure.  
Only configuration and metadata differ, ensuring a consistent, maintainable, and environment-agnostic design across all sources.

---

## Purpose

The pipeline ingests datasets from the designated source system into the `dbb_lakehouse`.  
It uses **version-controlled metadata** and **parameterized configuration** to dynamically resolve what to ingest, where to ingest it, and how to execute the load.  
This ensures data ingestion is flexible, fully traceable, and aligned with DBB’s governed integration standards.

---

## Pipeline Architecture

The pipeline consists of the following key components:

![Integration Source Pipeline Example](/.attachments/Schermafbeelding%202025-10-20%20170402-82251413-d93f-4efb-a88f-84f2da599b52.png)

1. **Lookup – integration_source_connections.csv**  
   Reads the file `integration/integration_source_connections.csv` to identify both the **source connection** and the **monitoring connection** for the current environment.  
   This file defines connection IDs and names for all sources and environments (see example below).

   The following variables are set:
   - `source_connection_id` – Connection ID for the active source system (e.g., Mona, Dynamics, GenericData).  
   - `monitoring_connection_id` – Connection ID for the monitoring warehouse (`dbb_warehouse`), used to store ingestion logs.

2. **Lookup – integration_source_list.csv**  
   Reads the metadata file `integration/<source_name>/integration_source_list.csv` from the Lakehouse to determine which tables or datasets should be ingested.

3. **Filtering and ForEach Loop**  
   - Only rows with `load_enabled = 'yes'` are processed.  
   - Each dataset in the filtered list is processed sequentially using a **ForEach loop**, performing lookup, extraction, and ingestion based on table-level JSON metadata.

---

## Metadata-Driven Design

The pipeline structure is fully **metadata-driven**.  
All logic and configuration are controlled via versioned metadata files stored in the DevOps repository and synchronized with Fabric.

### 1. Integration Source Connections
- Located at: `integration/integration_source_connections.csv`
- Defines all source and monitoring connection IDs by environment and workspace.
- Allows seamless multi-environment execution without code changes.

![integration_source_connections.csv Example](/.attachments/image-41566229-abfc-4761-90f8-46cf8e5b2c28.png)

### 2. Integration Source List
- Located at: `integration/<source_name>/integration_source_list.csv`
- Contains the list of datasets to ingest for a given source, with details such as:
  - schema_name  
  - table_name  
  - load_enabled  
  - load_type (FULL / INCREMENTAL)

![integration_source_list.csv Example](/.attachments/image-d1125bbc-87c1-4420-ab9b-53607d1fef8f.png)

### 3. Table-Level Metadata (JSON)
- Stored at: `integration/<source_name>/<schema_name>/<table_name>.json`
- Defines parameters for each dataset:
  - `query` – SQL or data extraction query  
  - `load_type` – FULL or INCREMENTAL  
  - `update_field` – Used for incremental logic  
  - `source_type` – SQL, API, or File-based  

These JSON files are version-controlled, ensuring transparency and consistent ingestion logic across all workspaces.

![<table_name>.json Example](/.attachments/image-58deb255-c75f-45c5-9ba8-9c4b07aaebad.png)

---

## Ingestion Logic

Each dataset listed in the integration source metadata follows a standardized ingestion sequence.  

The logic dynamically determines **what** data to load and **how** it should be extracted based on metadata and prior ingestion results.
  
![Ingestion Logic Flow](sandbox:/mnt/data/28fc515e-28bd-461c-b5dc-e09d67ef3038.png)

### **1. Metadata Lookup**

The pipeline retrieves JSON metadata for the current dataset using the `lookup_integration_source_metadata` activity.  

This metadata file defines:

- The **base SQL query** to extract data  
- The **load type** (`FULL` or `INCREMENTAL`)  
- The **update field** used for incremental loads  

Example location:  

`integration/<source_name>/<schema_name>/<table_name>.json`


### **2. Watermark Lookup**

The next step uses the `lookup_integration_source_watermark` activity to determine the appropriate **watermark date** for the load.  
This value is fetched from the DBB monitoring table `dbb_warehouse.meta.monitoring_integration`.

**Logic:**

```sql

IF '@{activity('lookup_integration_source_metadata').output.firstRow.load_type}' = 'INCREMENTAL'
BEGIN
    SELECT
        COALESCE(FORMAT(MAX([timestamp]), 'yyyy-MM-dd HH:mm:ss.fff'), '0000-00-00 00:00:00') AS watermark_date
    FROM
        [dbb_warehouse].[meta].[monitoring_integration]
    WHERE
        [table_name] = '@{item().table_name}'
        AND [schema_name] = '@{item().schema_name}'
        AND [source_name] = '@{pipeline().parameters.source_name}'
        AND [status] = 'Succeeded'
END
ELSE
BEGIN
    SELECT TOP 1
        '0000-00-00 00:00:00' AS watermark_date
    FROM
        [dbb_warehouse].[meta].[monitoring_integration]
END

```
- For **FULL loads**, the default watermark `'0000-00-00 00:00:00'` is used.  
- For **INCREMENTAL loads**, the most recent successful ingestion timestamp from the monitoring table is used.

### **3. Query Construction**

The **Copy Data** activity dynamically builds the SQL extraction query based on the load type.

**Logic:**

```text

@{if(
    equals(activity('lookup_integration_source_watermark').output.firstRow.watermark_date,'0000-00-00 00:00:00'),
    activity('lookup_integration_source_metadata').output.firstRow.query
    concat(
        activity('lookup_integration_source_metadata').output.firstRow.query,
        ' WHERE ',
        activity('lookup_integration_source_metadata').output.firstRow.update_field,
        ' >= ',
        '''',
        activity('lookup_integration_source_watermark').output.firstRow.watermark_date,
        ''''
    )
)}

```
- If the watermark is `'0000-00-00 00:00:00'`, the **base query** from metadata is executed (**FULL load**).  
- If the watermark is a valid timestamp, the query dynamically adds a **WHERE** clause using the defined `update_field` (**INCREMENTAL load**).  

This ensures that only new or changed records are ingested since the last successful run.

### **4. Data Load Execution**

The generated query runs against the **source system connection**, and data is copied into the target `dbb_lakehouse`.  

Each dataset is written to:

```

dbo.<SourceName>__<SchemaName>_<TableName>

```
The write mode is set to **OverwriteSchema** to maintain schema consistency across ingestions.

If the **Copy Data** activity fails, the `integrate_source_table_fail` activity captures the failure and logs the details for diagnostics.


### **5. Monitoring and Logging**

After each ingestion completes (successful or failed), the pipeline executes the **Script activity** `script_monitoring_integration`.  

This writes ingestion metrics to the monitoring table `dbb_warehouse.meta.monitoring_integration`, including:

- Source, schema, and table names  
- Load type and status  
- Row counts and duration  
- Watermark used for incremental loads  

These monitoring records are used by the **DBB Monitoring Framework** for validation, reporting, and alerting.  

(See [monitoring_integration](/Data-BackBone-Fabric-Implementation-Documentation/50.-Monitoring/monitoring_operations/monitoring_integration) for more details.)
