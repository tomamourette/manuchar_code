# reconciliation_pipeline_DBB

[[_TOC_]]

## Overview
The `reconciliation_pipeline_DBB` is a **generic Fabric Data Pipeline** that executes reconciliation checks following the transformation stage of each Data Product.  
It ensures that data integrity, consistency, and business validation rules are met before the data is exposed to the semantic and reporting layers.

This pipeline runs automatically after the successful completion of the `transformation_pipeline_DBB`, as part of the data product orchestration sequence.  
(See [orchestration_pipeline_<Data Product>](/Data-BackBone-Fabric-Implementation-Documentation/00.-Orchestration-&-Components/Orchestration/orchestration_pipeline_<Data-Product>) for details on execution flow.)

---

## Purpose
- Perform reconciliation and validation checks on recently transformed data.  
- Ensure consistency between source, integration, and warehouse layers.  
- Prevent semantic refreshes from running if data quality checks fail.  
- Maintain traceability across orchestration runs through shared identifiers.

---

## Pipeline Components

![Reconciliation Pipeline Diagram](/.attachments/image-1bd0a390-f2aa-4c27-b980-a5fdd20d03fc.png)

### 1. Environment and Configuration Resolution
The pipeline begins with a lookup on `[dbb_warehouse].[meta].[environments]` to dynamically resolve environment-specific context based on the current `workspace_id`.

The following variables are set:

| Variable | Description |
|-----------|--------------|
| **environment** | Found based on the current `workspace_id` from `meta.environments`; used as the target for reconciliation. |
| **data_product** | Parameter passed by the orchestration pipeline. |
| **reconciliation_pipeline_id** | The static Fabric ID of the reconciliation pipeline. |
| **reconciliation_pipeline_run_id** | The runtime ID generated for the current reconciliation pipeline execution. |
| **orchestration_run_id** | Parameter passed from the orchestration pipeline for end-to-end traceability across data product runs. |

These variables ensure that reconciliation logic executes in the correct environment and links to the appropriate orchestration cycle.

---

### 2. Reconciliation Notebook Execution
The main activity in this pipeline invokes the **`reconciliation_notebook`**, which runs data validation and reconciliation checks for the active Data Product.

For the **Group Financial Statements** Data Product, this includes:
- Comparing **MONA source data** against **DBB fact amounts**, ensuring alignment by **Company**, **Period**, and **KPI Measure**.
- ...

> For detailed information about the reconciliation logic and implementation, see  
> [reconciliation_notebook](reconciliation_notebook)

---

### 3. Conditional Validation and Failure Handling
After the notebook completes, an **If Condition** activity checks whether the reconciliation succeeded.  

- **If True:** The pipeline completes successfully and orchestration can continue to the next stage (`data_product_refresh_DBB`).  
- **If False:** The pipeline is **explicitly failed**, stopping orchestration from triggering the semantic model refresh step.

This ensures that **data products with failed reconciliation checks are not published** until validation issues are resolved.

---

## Execution Dependencies
The `reconciliation_pipeline_DBB` is invoked by the orchestration pipeline **after a successful transformation run**.  
It depends on the completion and success of `transformation_pipeline_DBB` to ensure that reconciliations are executed on finalized, transformed data.

---

## Output and Impact
Upon completion, the reconciliation pipeline:
- Executes all reconciliation checks defined for the active Data Product.  
- Logs validation outcomes and quality metrics to monitoring tables.  
- Fails safely if checks are unsuccessful, preventing semantic model refresh.  
- Contributes to DBB’s governed and auditable data delivery process.

This standardized reconciliation pipeline provides a controlled quality assurance step across all Data Products in the DBB platform.
