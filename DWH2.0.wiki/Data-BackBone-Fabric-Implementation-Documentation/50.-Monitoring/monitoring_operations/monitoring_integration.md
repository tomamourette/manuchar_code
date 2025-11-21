# Monitoring – Integration Operations

This page describes the **operational monitoring setup** for integration pipelines within the Data BackBone (DBB) platform.  

It focuses on the process used to capture and store **ingestion metadata** during the execution of each `integration_pipeline_source_<Source System>`.

---

## Purpose

The **Integration Monitoring** process logs all relevant metadata from the execution of integration pipelines into a centralized warehouse table:  

`[dbb_warehouse].[meta].[monitoring_integration]`.

This table provides traceability across data sources, tables, environments, and orchestration runs, supporting performance analysis, troubleshooting, and operational visibility.

---

## Monitoring Flow

During each run of an **integration source pipeline**, metadata is written to the monitoring table via a **Script activity**.  
This activity is executed at the end of each dataset ingestion process, capturing key operational metrics such as duration, throughput, and data volume.

The script performs an `INSERT` into the monitoring table as shown below:  

---

## Captured Metadata

| Field | Description |
|-------|--------------|
| **table_name** | Name of the ingested table. |
| **schema_name** | Schema name of the ingested dataset. |
| **source_name** | Name of the source system (e.g., Dynamics, Mona). |
| **source_type** | Source type (e.g., SQL, API, File). |
| **load_type** | Defines whether the load is `FULL` or `INCREMENTAL`. |
| **workspace** | The Fabric workspace where the pipeline executed. |
| **status** | Status of the ingestion activity (Succeeded / Failed). |
| **timestamp** | Timestamp of the ingestion run. |
| **duration** | Total runtime of the copy activity (in seconds). |
| **throughput** | Data transfer rate measured during execution. |
| **data_read / data_written** | Bytes read and written during ingestion. |
| **rows_read / rows_written** | Row counts processed during ingestion. |
| **data_product** | Name of the Data Product associated with this integration run. |
| **orchestration_run_id** | Identifier of the orchestration pipeline that triggered the integration run. |
| **integration_pipeline_source_run_id** | Run ID of the source-specific integration pipeline. |
| **integration_pipeline_id** | Unique identifier of the integration pipeline definition. |

---

## Usage

This monitoring logic enables:

- Full **traceability** of ingestion runs from orchestration down to individual table loads.  
- Real-time **visibility** of ingestion performance and data volumes.  
- Seamless **integration with downstream monitoring dashboards** and alerting mechanisms.  
- Support for **incremental loading** by using the recorded timestamps as watermarks.  

---

## Next Steps

Monitoring data from `meta.monitoring_integration` is leveraged in:
- **Transformation notebooks** to check for failed source tables before running dbt models.  
- **Reconciliation checks** to validate successful upstream ingestion.  
- **Operational dashboards** that visualize ingestion health and throughput over time.  
