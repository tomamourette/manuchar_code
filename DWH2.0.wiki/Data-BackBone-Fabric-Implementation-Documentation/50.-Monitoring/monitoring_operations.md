# Monitoring – Operations

The **Monitoring – Operations** framework provides detailed tracking of all operational activities that occur within the **orchestration pipeline jobs**.  
It captures execution metadata across the three core workloads of the Data BackBone (DBB) platform — **Integration**, **Transformation**, and **Consumption** — ensuring traceability, performance insights, and error diagnostics at the table, model, and semantic model level.

---

## Purpose

Operational monitoring focuses on **what happens inside each orchestration job**.  
While orchestration-level monitoring tracks pipeline dependencies and run statuses, operational monitoring drills deeper to capture the **technical details of each data movement and transformation step**, including:

- Which source tables were ingested and their load statistics.  
- Which dbt models were executed and their results.  
- Which semantic models were refreshed and the duration/status of each refresh.

All operational monitoring data is written into dedicated warehouse tables in the schema `[dbb_warehouse].[meta]`.

---

## Overview of Operational Monitoring Tables

| Table | Description |
|--------|--------------|
| **meta.monitoring_integration** | Logs metadata about ingested tables from each [integration_pipeline_<Data-Product>](/Data-BackBone-Fabric-Implementation-Documentation/10.-Integration/integration_pipeline_<Data-Product>). Includes record counts, data volume, duration, and load status per table. |
| **meta.monitoring_transformation_dbt** | Captures the detailed execution results of dbt models executed in the [transformation_notebook](/Data-BackBone-Fabric-Implementation-Documentation/20.-Transformation/transformation_notebook). Includes dbt node statuses, durations, errors, and performance metrics. |
| **meta.monitoring_semantic_model_refresh** | Tracks Semantic Model Refreshes executed in the [data_product_refresh_DBB](/Data-BackBone-Fabric-Implementation-Documentation/40.-Consumption/data_product_refresh_DBB). Records refresh start/end times, duration, and outcome for each model. |

Each of these tables is designed to provide end-to-end traceability between the **orchestration_run_id** and the operational step it represents.

---

## Linkage to Orchestration Runs

Every record across the monitoring tables includes a reference to the **orchestration_run_id**, allowing analysts to trace a complete orchestration execution:

- From the **orchestration pipeline** →  
  to the **integration pipeline** →  
  through the **transformation pipeline** →  
  and finally the **data product refresh**.

This ensures that all operational events from ingestion to reporting are traceable under a single orchestration cycle.

---

## Example Use Cases

- **Data lineage validation** — Trace which source tables were ingested for a given orchestration run.  
- **Performance monitoring** — Analyze durations and throughput for integration and transformation steps.  
- **Error diagnostics** — Identify failed dbt models or incomplete semantic model refreshes.  
- **Audit & compliance** — Provide a complete run history for each data product across environments.

---

## Relation to Monitoring – Orchestration

- **Monitoring – Operations** focuses on *what happens inside each job* (table loads, model builds, refreshes).  
- **Monitoring – Orchestration** focuses on *how these jobs are executed and controlled* (dependencies, triggers, scheduling, success/failure flow).

Together, they form a comprehensive monitoring framework for DBB pipeline governance and observability.

---
