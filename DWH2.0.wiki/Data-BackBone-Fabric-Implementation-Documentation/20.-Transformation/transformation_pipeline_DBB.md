# transformation_pipeline_DBB

[[_TOC_]]

## Overview

The `transformation_pipeline_DBB` in the Data BackBone (DBB) platform is a **metadata-driven Fabric Data Pipeline** that executes the transformation workload for a given Data Product.  
It is responsible for invoking the dbt-based transformation notebook, validating outputs, refreshing metadata, and logging execution telemetry.

This pipeline runs **after completion of the integration phase** for the same Data Product, ensuring that all required source data has been ingested and validated before transformation begins.  
(See [orchestration_pipeline_<Data Product>](/Data-BackBone-Fabric-Implementation-Documentation/00.-Orchestration-&-Components/Orchestration/orchestration_pipeline_<Data-Product>) for details on orchestration dependencies.)

---

## Purpose

The purpose of this pipeline is to:
- Execute the transformation logic associated with a Data Product (using dbt models or tagged model groups)
- Validate the transformation process and resulting datasets

This pipeline is **generic** and reused across Data Products — all parameters and configurations are resolved dynamically through metadata or orchestration inputs.

---

## Pipeline Components

![Transformation Pipeline Diagram](/.attachments/image-9eb61a1c-4be1-40b0-91e9-cea6c4cc2599.png)

### 1. Environment and Configuration Resolution

The pipeline starts with a lookup against the metadata table `[dbb_warehouse].[meta].[environments]`.  
This step resolves environment-specific variables dynamically based on the current `workspace_id`.

The following variables are set:

| Variable | Description |
|-----------|--------------|
| **environment** | Found based on the current `workspace_id` from `meta.environments`; used as the target for transformation. |
| **warehouse_id** | Retrieved from `meta.environments`; defines the target warehouse for dbt model execution. |
| **models** | The dbt model tag(s) to execute, dynamically set as `@concat('+tag:', pipeline().parameters.data_product)` to scope models for the active Data Product. |
| **data_product** | Parameter passed by the orchestration pipeline. |
| **orchestration_run_id** | Parameter passed by the orchestration pipeline to maintain traceability across integration and transformation runs. |
| **transformation_pipeline_run_id** | Runtime ID of the current transformation pipeline run. |
| **transformation_pipeline_id** | Static ID of the current transformation pipeline definition in Fabric. |

These variables are used throughout the downstream activities to ensure dynamic parameterization across all environments (TST, ACC, QUAL, PRD).

---

### 2. Transformation Execution

The central step is the execution of the `transformation_notebook`, which:
- Runs dbt model transformations for the current Data Product.
- Applies logic defined in dbt packages using the model tag resolved in the pipeline.
- Performs validation and dependency checks to confirm all required integration data has successfully loaded.  

> **Note:**  
> The dependency on the preceding integration pipeline (`integration_pipeline_<Data Product>`) is handled inside the transformation notebook itself.  
> It ensures the transformation only proceeds if the related source tables of the data product have completed successfully for the same `orchestration_run_id`.  
> (See [tranformation_notebook](transformation_notebook) for detailed logic.)

---

### 3. Monitoring

After successful execution of the transformation notebook, the `monitoring_notebook_transformation` is triggered.  
It logs execution metadata such as:
- Start and end times
- Run duration
- Pipeline and orchestration run IDs
- Status (Succeeded/Failed)
- Row counts and model execution stats

These metrics are stored in `[dbb_warehouse].[meta].[monitoring_transformation]` and can be visualized or queried for performance auditing.  
(See [monitoring_transformation](/Data-BackBone-Fabric-Implementation-Documentation/50.-Monitoring/monitoring_operations/monitoring_transformation) for more details.)

---

### 4. Maintenance

The pipeline executes the `maintenance_notebook_metadata_refresh` notebook following transformation.  
This ensures metadata alignment across Fabric artifacts and Power BI datasets by:
- Refreshing schema metadata for newly transformed models
- Ensuring discoverability through the semantic layer
- Preventing stale metadata in downstream tools

---

### 5. Conditional Validation and Failure Handling

After the maintenance step, an `If Condition` activity checks whether the transformation succeeded.  
If the notebook reports a failure status, the pipeline triggers a controlled failure event to stop propagation and record detailed logs for diagnostics.  

---

## Dependency on Integration Pipeline

The transformation pipeline is **dependent on the completion of the integration pipeline** for the same Data Product.  
Execution is configured as **“Run on completion”** of `integration_pipeline_<Data Product>` within the orchestration framework.  
This ensures that:
- Integration loads are fully completed and validated before transformation starts.
- The `transformation_notebook` can validate ingestion success using shared metadata in `dbb_warehouse.meta.monitoring_integration`.

Dependency handling and validation logic are implemented directly inside the transformation notebook.  
(See [tranformation_notebook](transformation_notebook) for details.)

---

## DBB Platform Workload Alignment

| Workload | Description |
|-----------|--------------|
| **Transformation** | Executes Spark-based dbt models to produce curated, business-ready data. |
| **Monitoring** | Captures execution telemetry and data quality metrics. |
| **Maintenance** | Refreshes Fabric and Power BI metadata to ensure alignment and discoverability. |

---

## Output and Impact

Upon completion, the `transformation_pipeline_DBB`:
- Executes all dbt models tagged for the Data Product
- Ensures integration dependencies are met before transformation
- Validates output datasets and logs execution metadata

This standardized transformation pipeline design ensures scalability, traceability, and governance across all Data Products within the DBB platform.