# Monitoring – Transformation Operations (dbt)

This page documents the **operational monitoring** captured during the **Transformation** workload.  

The metrics are produced **inside the `transformation_notebook`** after each dbt build and appended to the warehouse table:

```

[dbb_warehouse].[meta].[monitoring_transformation_dbt]

```

---

## Purpose

- Persist detailed **dbt run results** (per item/process stage) for traceability and troubleshooting.  

- Link transformation activity to **Data Product**, **orchestration run**, **pipeline run**, and **workspace**.  

 
---


## Monitoring Flow

1. The notebook runs `dbt build` and writes artifacts under:

```

/lakehouse/default/Files/monitoring/transformation_dbt_{transformation_timestamp}/run_results.json

```

2. The notebook **reads and flattens** `run_results.json` (per dbt node and timing stage).  

3. Enriches the records with **contextual parameters** passed by the pipeline.  

4. Appends the results to **`meta.monitoring_transformation_dbt`** in the warehouse.

---

## Captured Fields and Sources


| Field | Description |
|-------|--------------|
| **item_name** | dbt node name (model, test, seed, etc.), trimmed to the last segment from `run_results.results[*].unique_id`. |
| **invocation_id** | Unique identifier for the dbt run (`run_results.metadata.invocation_id`). |
| **status** | Execution status of the dbt node (e.g., success, error, skipped). |
| **thread_id** | Identifier of the dbt worker thread that executed the node. |
| **execution_time** | Total execution time of the dbt node in seconds. |
| **failures** | Failure flag or count for the node (if provided). |
| **compiled** | Indicates whether the dbt node compiled successfully. |
| **relation_name** | Target relation name created or updated by the node (e.g., `schema.object`). |
| **adapter_message** | Message returned by the dbt adapter (e.g., SQL execution details). |
| **rows_affected** | Number of rows affected by the operation, if available. |
| **process_stage** | Stage name within dbt timing (e.g., compile, execute). |
| **process_started_at** | Stage start timestamp (converted to datetime). |
| **process_completed_at** | Stage end timestamp (converted to datetime). |
| **duration** | Duration of the dbt process stage in seconds (`completed - started`). |
| **generated_at** | Timestamp when the dbt artifacts were generated. |
| **environment** | Environment tag (e.g., `TST`, `QUAL`, `PRD`), passed as a notebook parameter. |
| **build_models** | The dbt selector used for this run (e.g., `+tag:Group-FinancialStatements`). |
| **orchestration_run_id** | ID linking the run back to the parent orchestration pipeline. |
| **data_product** | The name of the active Data Product being built. |
| **transformation_pipeline_run_id** | Run ID of the current transformation pipeline. |
| **workspace_id** | Fabric workspace ID retrieved from the runtime context. |
| **transformation_pipeline_id** | ID of the transformation pipeline executed in Fabric. |

---
 

## Usage

- Analyze **per-model** and **per-stage** timings to detect performance regressions.  

- Correlate outcomes with **Data Product**, **orchestration run**, and **pipeline run** for end-to-end lineage.  

- Drive **operational dashboards** (success rates, durations, rows affected) and **alerts** on failures.
  
---
 
## Related Docs

- [transformation_notebook](/Data-BackBone-Fabric-Implementation-Documentation/20.-Transformation/transformation_notebook) – execution & monitoring logic

- [transformation_pipeline_DBB](/Data-BackBone-Fabric-Implementation-Documentation/20.-Transformation/transformation_pipeline_DBB) – parameters passed to the notebook