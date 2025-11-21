# Monitoring – Semantic Model Refresh

This page documents the **operational monitoring** captured after a **semantic model refresh** in the **Consumption** workload.  

The metrics are produced by the `monitoring_notebook_semantic_model_refresh`, which runs at the end of the `data_product_refresh_DBB` pipeline and appends rows to:

```

[dbb_warehouse].[meta].[monitoring_semantic_model_refresh]

```

---

## Purpose

- Persist **dataset refresh telemetry** (start/end time, duration, status) for each Data Product’s semantic model.  

- Link refresh executions to the **orchestration run** and **pipeline run** for end-to-end lineage.  

---

## Monitoring Flow

1. The notebook queries Fabric using **`sempy.fabric.list_refresh_requests`** for the target **workspace** and **semantic model** (`top_n=1`) to retrieve the **latest refresh request**.  

2. The result is flattened and enriched with context (workspace, model, data product, orchestration run, pipeline ids).  

3. The data is written (created if needed) to **`meta.monitoring_semantic_model_refresh`** in the warehouse. 

---

## Captured Fields and Sources

| Field | Description |
|-------|--------------|
| **workspace_id** | ID of the Fabric workspace hosting the semantic model. |
| **semantic_model_id** | ID of the semantic model that was refreshed (retrieved from `[meta].[data_product_models]`). |
| **data_product** | Name of the Data Product being refreshed. |
| **orchestration_run_id** | Identifier of the orchestration pipeline that triggered the refresh. |
| **process_started_at** | Refresh start timestamp retrieved from `list_refresh_requests`. |
| **process_completed_at** | Refresh end timestamp retrieved from `list_refresh_requests`. |
| **duration** | Total refresh duration in seconds (derived from start and end times). |
| **status** | Final refresh status (e.g., `Succeeded`, `Failed`). |
| **data_product_refresh_pipeline_run_id** | Run ID of the current data product refresh pipeline execution. |
| **data_product_refresh_pipeline_id** | Fabric pipeline ID for the refresh pipeline. |

---

## Usage

- Track **success/failure** and **duration** of semantic model refreshes per Data Product.  

- Correlate refreshes with upstream **ingestion** and **transformation** runs through the shared `orchestration_run_id`.  
- Power **operational dashboards** and **alerts** for failed or slow refreshes.

---

## Related Docs

- [data_product_refresh_DBB](/Data-BackBone-Fabric-Implementation-Documentation/40.-Consumption/data_product_refresh_DBB) – pipeline that triggers the refresh and monitoring notebook.    
