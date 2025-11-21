integration_pipeline_<Data Product> – DBB Data Product Integration

[[_TOC_]]

## Overview
The `integration_pipeline_<Data Product>` defines the ingestion flow for a specific Data Product within the Data BackBone (DBB) platform.  
It is responsible for orchestrating the loading of mirrored or raw source data into the `dbb_lakehouse`, using environment-aware configuration and parameterized execution.

Each Data Product has its own dedicated integration pipeline (e.g. `integration_pipeline_GroupFinancialStatements`) that coordinates ingestion from multiple source systems required for that Data Product.

---

## Purpose

The purpose of this pipeline is to dynamically resolve environment configuration, ingest all relevant source data, and prepare it for transformation and validation.  
It ensures that ingestion runs are **fully traceable**, **metadata-driven**, and **consistent across environments**.

---

## Pipeline Architecture

The pipeline consists of four main stages, as illustrated below:

![Schermafbeelding 2025-10-20 161654.png](/.attachments/Schermafbeelding%202025-10-20%20161654-d644e6b0-d853-4b9f-98be-0f6c48b2565e.png)

---

## Environment and Configuration Resolution

The pipeline starts by performing a **lookup** in the metadata table `dbb_warehouse.meta.environments`, which stores configuration details per Fabric workspace.

The following variables are set based on the current workspace ID:

| Variable | Description |
|-----------|--------------|
| **integration_lakehouse** | Found based on the current `workspace_id` from `meta.environments`; used as the target for ingestion. |
| **transformation_warehouse** | Found based on the current `workspace_id`; used by downstream dbt transformations. |
| **sql_connection_string** | Found based on the current `workspace_id`; defines the source connection for integration. |
| **environment_name** | Derived from the `meta.environments` lookup (e.g., TST, ACC, QUAL, PRD). |
| **ingestion_timestamp** | Current timestamp at the start of the integration load. |
| **orchestration_run_id** | Parameter passed by the orchestration pipeline that invoked this integration pipeline (see [orchestration_pipeline_<Data Product>](/Data-BackBone-Fabric-Implementation-Documentation/00.-Orchestration-&-Components/Orchestration/orchestration_pipeline_<Data-Product>)). |

These variables provide full flexibility and traceability, ensuring the same pipeline logic operates consistently across environments.

---

## Source-Specific Ingestion

Each Data Product integration pipeline invokes one or more **source-specific ingestion pipelines**, depending on its data dependencies.  
These pipelines handle ingestion from different operational or mirrored systems into `dbb_lakehouse`.

For example, for the *Group Financial Statements* Data Product, the following sources are invoked:

* `integration_pipeline_source_Mona`  
* `integration_pipeline_source_MDS`  
* `integration_pipeline_source_dbb_lakehouse` (later *MIRROR* to `OSS_GenericData_MHQ_Warehouse`)

Each sub-pipeline receives a standardized set of **runtime parameters** from the parent `integration_pipeline_<Data Product>`, ensuring consistency and traceability across all ingestion executions.

![Schermafbeelding 2025-10-20 170219.png](/.attachments/Schermafbeelding%202025-10-20%20170219-73a16806-0e83-4bd8-9105-a6bb396e4a28.png)

#### Parameters passed to source-specific ingestion pipelines

| Parameter | Description | Source |
|------------|-------------|---------|
| **source_name** | Logical name of the source being ingested (e.g., Mona, MDS, GenericData, dbb_lakehouse). | Defined directly in the parent pipeline before invoking the sub-pipeline. |
| **integration_lakehouse** | Target Lakehouse for ingestion. | Retrieved dynamically from the `meta.environments` table. |
| **transformation_warehouse** | Warehouse used for downstream transformations. | Retrieved dynamically from the `meta.environments` table. |
| **sql_connection_string** | Connection string for accessing source systems. | Retrieved dynamically from the `meta.environments` table. |
| **environment** | The current Fabric environment (TST, ACC, QLT, PRD). | Retrieved dynamically from the `meta.environments` table. |
| **ingestion_timestamp** | Timestamp generated at the start of the integration run. | Created at runtime in the parent pipeline. |
| **database_name** | Name of the integration database (`dbb_lakehouse`). | Defined statically. |
| **data_product** | Name of the Data Product. | Derived dynamically from the pipeline name. |
| **orchestration_run_id** | Unique run ID from the orchestration pipeline. | Passed as a parameter from the orchestration pipeline. |

Each of these parameters is automatically created or resolved in the parent `integration_pipeline_<Data Product>` before invoking any source-specific pipeline.  

This parameterization ensures that all downstream ingestion pipelines run in a **consistent**, **metadata-driven**, and **fully traceable** manner across all environments.

---

## Maintenance

Once all source ingestion steps are complete, the pipeline runs the **maintenance notebook** (`maintenance_notebook_metadata_refresh`).  
This notebook refreshes metadata in the `dbb_lakehouse`, ensuring that table structures and schema changes are correctly registered and available for downstream transformation and monitoring.

---

## Monitoring

After maintenance, the **monitoring notebook** (`monitoring_notebook_integration_validation`) is executed.  
This notebook performs integration-level validation checks, such as:

* Verifying that all expected tables were ingested.  
* Validating record counts and ingestion timestamps.  
* Logging results for traceability and alerting.

Monitoring results are recorded in the DBB monitoring framework for operational visibility.  
(See [Monitoring Documentation](/Data-BackBone-Fabric-Implementation-Documentation/50.-Monitoring) for more details.)

---

## Output and Impact

Upon completion, the `integration_pipeline_<Data Product>`:

* Ingests data from all relevant sources into the `dbb_lakehouse`.  
* Ensures all ingested data is traceable using a unified **ingestion timestamp** and **orchestration run ID**.  
* Refreshes metadata definitions to align with the latest ingestion results.  
* Executes monitoring checks to validate ingestion quality and completeness.  

This pipeline forms a critical part of the DBB **integration workload**, standardizing data ingestion across all Data Products while ensuring consistency, traceability, and operational reliability.
