# transformation_notebook

[[_TOC_]]

## Overview
The `transformation_notebook` is the **generic Fabric notebook** that executes dbt models for a given **Data Product** within the Data BackBone (DBB) platform.  
It is invoked by the `transformation_pipeline_DBB` and fully parameterized so the same notebook can be used for every data product orchestration run.

This notebook also enforces the dependency on the **integration pipeline** by validating that the latest integration run for the same data product and orchestration run completed successfully before executing any dbt logic.

---

## Purpose
- Execute dbt models for the specified **Data Product**.
- Validate that all relevant **integration tables** were successfully ingested.
- Persist dbt execution metadata to `dbb_warehouse.meta.monitoring_transformation_dbt`.
- Authenticate dbt with Azure Fabric using a service principal and Key Vault secrets.

---

## Parameters (Injected by `transformation_pipeline_DBB`)

| Parameter | Description |
|------------|--------------|
| **environment** | Environment (e.g., `tst`, `acc`, `qual`, `prd`) determining dbt target. |
| **models** | dbt selector defining which models to build (e.g., `+tag:Group-FinancialStatements`). |
| **data_product** | Name of the active Data Product. |
| **orchestration_run_id** | Run ID passed by the orchestration pipeline for traceability. |
| **transformation_pipeline_run_id** | Runtime ID of the current transformation pipeline run. |
| **transformation_pipeline_id** | Pipeline definition ID of the transformation pipeline. |

All parameters are automatically set by the parent pipeline before notebook execution.

---

## Execution Flow

### 1. Context Initialization
- Generate a **transformation timestamp** for run tracking and file naming.  
- Install dependencies such as the Fabric dbt adapter (`dbt-fabric==1.7.4`).

### 2. Authentication via Key Vault
- Retrieve **service principal credentials** and **dbt endpoint URLs** from Azure Key Vault.  
- For **QUAL**, a temporary setup uses the PRD Key Vault with a QUAL endpoint.  
- Credentials (Client ID, Secret, Tenant ID, Endpoint) are injected as environment variables for dbt authentication.

### 3. Integration Dependency Validation
- Query `dbb_warehouse.meta.monitoring_integration` for the **latest orchestration run** of the same `data_product`.
- Identify any **failed tables** in that run:
  - If failures are found → raise an exception and **stop** the notebook.
  - If all succeeded → continue with dbt model execution.
  
> This enforces orchestration’s “run on completion” logic:  
> while the transformation pipeline starts regardless of integration status, the notebook itself decides whether transformation can proceed.  
> See [orchestration_pipeline_<Data Product>](/Data-BackBone-Fabric-Implementation-Documentation/10.-Integration/integration_pipeline_<Data-Product>) and [transformation_pipeline_<Data Product>](/Data-BackBone-Fabric-Implementation-Documentation/20.-Transformation/transformation_pipeline_DBB) for details.

### 4. Execute dbt
- Define a monitoring folder (e.g., `/monitoring/transformation_dbt_<timestamp>`).  
- Run:
  - `dbt deps` – install dependencies.  
  - `dbt build --target <environment> --select "<models>"` – build all tagged models for the data product.

### 5. Persist dbt Run Results
- Read `run_results.json` from the monitoring folder.  
- Flatten and enrich run data (status, timing, duration, rows affected, etc.).  
- Add contextual fields:
  - `environment`, `models`, `data_product`,  
  - `orchestration_run_id`, `transformation_pipeline_run_id`, `workspace_id`, `transformation_pipeline_id`.
- Append results into the warehouse table:  
  **`dbb_warehouse.meta.monitoring_transformation_dbt`**.

---

## Failure Handling
- If integration validation fails → notebook raises an exception and halts execution.  
- If dbt execution fails → notebook raises an exception but still logs metadata when possible.  
- The parent transformation pipeline contains an *If Condition* to mark the overall pipeline run as failed if this notebook fails.

---

## Output and Impact
- dbt models for the selected Data Product are built and materialized in **`dbb_warehouse`**.  
- dbt logs and result artifacts are saved to the monitoring folder.  
- Execution telemetry is logged in **`meta.monitoring_transformation_dbt`** for traceability.  
- The notebook ensures only **validated, successfully integrated** source data is used in transformations.

---
