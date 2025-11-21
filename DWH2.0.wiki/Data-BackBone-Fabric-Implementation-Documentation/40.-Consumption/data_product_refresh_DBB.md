# data_product_refresh_DBB

[[_TOC_]] 

## Overview

The **`data_product_refresh_DBB`** pipeline belongs to the **Consumption workload** in the Data BackBone (DBB) platform.  

It is responsible for refreshing the **Power BI semantic models** associated with each Data Product after successful completion of the Integration, Transformation, and Reconciliation pipelines.

This pipeline ensures that the latest curated data becomes available for analytics and reporting in Microsoft Fabric, Power BI, and Excel.

--- 

## Purpose

The purpose of this pipeline is to:

- Refresh the semantic model(s) for the given Data Product based on the most recent transformation output.  

- Validate successful refresh execution and log metadata for monitoring and traceability.  

- Maintain data freshness and consistency between DBB layers and end-user reporting environments.

---

## Pipeline Components

![Data Porduct Refresh Diagram.png](/.attachments/image-8566ec8f-5b7c-40dd-848a-4b0759633616.png)

### Environment and Configuration Resolution

The pipeline starts by retrieving environment-specific information from the metadata table:

```

[dbb_warehouse].[meta].[environments]

```

The following variables are set:
| Variable | Description |
|-----------|--------------|
| **environment** | Derived from `meta.environments` based on the current Fabric workspace ID; determines the target environment for refresh. |
| **data_product** | Passed as a parameter by the orchestration pipeline. |
| **orchestration_run_id** | Passed by the orchestration pipeline to link all workloads to the same execution context. |
| **data_product_refresh_pipeline_run_id** | The current pipeline run ID used for traceability. |
| **data_product_refresh_pipeline_id** | The Fabric pipeline ID used for metadata tracking. |

---

### Semantic Model Lookup

The pipeline performs a lookup on:

```

[dbb_warehouse].[meta].[data_product_models]

```

to retrieve information about which semantic model(s) belong to the Data Product for the given environment.

From this lookup, the following variables are set:

| Variable | Description |
|-----------|--------------|
| **model_id** | ID of the semantic model(s) to refresh. |
| **workspace_id** | ID of the Fabric workspace hosting the model(s). For Finance-related Data Products, this is typically the *Operational Integration Layer [<environment>]* workspace. |

---

### Semantic Model Refresh

The pipeline then executes a **Semantic Model Refresh** activity that triggers Power BI/Fabric model refreshes for the resolved model IDs.  

The refresh operation ensures that the latest curated and validated data is available in Power BI reports.

---

### Monitoring

After the model refresh completes, the **`monitoring_notebook_semantic_model_refresh`** notebook is executed.  

This notebook:

- Logs model refresh results (success/failure, duration, dataset name).  

- Captures metadata for operational observability.  

- Links the refresh execution to the originating orchestration run.

> See the [Monitoring documentation](monitoring_notebook_semantic_model_refresh) for more information on semantic model monitoring logic.

---

## Output and Impact

Upon completion, the pipeline:

- Refreshes the defined semantic models for the specified Data Product.  

- Logs execution details in the monitoring layer.  

- Ensures that only validated, up-to-date data reaches Power BI consumers.

This marks the **final stage** in the DBB pipeline flow, bridging governed data processing with end-user analytics.