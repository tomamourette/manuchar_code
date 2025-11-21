# orchestration_pipeline_<Data Product> – DBB Data Product Orchestration

[[_TOC_]]

## Overview

The `orchestration_pipeline_<Data Product>` defines the **end-to-end execution flow** for a specific Data Product within the Data BackBone (DBB) platform.  

Each Data Product (e.g., *GroupFinancialStatements*) has its own dedicated orchestration pipeline that coordinates ingestion, transformation, reconciliation, and semantic model refresh in a controlled and automated sequence.

---

## Pipeline Architecture

Each orchestration pipeline consists of **four sequential jobs**, as shown in the figure below:

![Schermafbeelding 2025-10-20 144914.png](/.attachments/Schermafbeelding%202025-10-20%20144914-99acc5ae-3116-43a8-84d9-cfdbdb7fde14.png)

### 1. Integration Pipeline – `integration_pipeline_<Data Product>`

Handles the ingestion of raw or mirrored source data related to the specific Data Product into `dbb_lakehouse`.  

Each Data Product has its own integration pipeline, allowing custom ingestion logic where needed while following a standardized orchestration flow.

For monitoring purposes, the orchestration pipeline Run ID (`orchestration_run_id`) is passed as a parameter to this integration pipeline, enabling traceability across executions.


### 2. Transformation Pipeline – `transformation_pipeline_DBB`

Executes the dbt transformations to build and refresh all dbt models associated with the Data Product into `dbb_warehouse`.  

This is a generic pipeline that can be used for all data products and receives parameters from the orchestration pipeline to know which models to run.  
If the integration step had failed tables, the pipeline can still continue and build unaffected models.  
(See Transformation Pipeline Documentation for more details.)

For monitoring purposes, the orchestration pipeline Run ID (`orchestration_run_id`) and Data Product Name (`data_product`) are passed as a parameter to this transformation pipeline, enabling traceability across executions.


### 3. Reconciliation Pipeline – `reconciliation_pipeline_DBB`

Runs automated reconciliation and data quality checks after transformation is successfully completed.  

This ensures data consistency and business rule compliance before making data available for reporting.

For monitoring purposes, the orchestration pipeline Run ID (`orchestration_run_id`) is passed as a parameter to this reconciliation pipeline, enabling traceability across executions.


### 4. Data Product Refresh Pipeline – `data_product_refresh_DBB`

Performs semantic model refreshes (e.g., Power BI or Fabric models) for the specific Data Product.  

Triggered only upon successful completion of all previous steps, ensuring that refreshed models always represent validated, consistent data.

For monitoring purposes, the orchestration pipeline Run ID (`orchestration_run_id`) and Data Product Name (`data_product`) are passed as a parameter to this data product refresh pipeline, enabling traceability across executions.  

---

## Execution Flow and Dependency Rules

Each job block within the orchestration pipeline defines its **next action based on job outcome**, ensuring reliable control and traceability.

| Step  | Next Action Condition | Behavior  |
|--|--|--|
| **Integration → Transformation** | *On Completion (Success or Failure)* | The transformation step will start even if ingestion partially fails, as dependency resolution happens within `transformation_pipeline_DBB`. |
| **Transformation → Reconciliation** | *On Success* | Reconciliation only runs if the transformation completed successfully. |
| **Reconciliation → Data Product Refresh** | *On Success* | Refresh only proceeds when all checks and reconciliations pass. |

This approach allows flexible orchestration while ensuring data quality gates are enforced where required.

---

## Scheduling Strategy

Scheduling is configured **per Data Product**, based on business and operational requirements:

* In **Production (PRD)**, schedules may vary by Data Product depending on source system refresh frequency and reporting needs.  

* In **Quality (QLT)**, the orchestration pipeline runs more frequently than in TST/ACC but at a lower pace than in PRD. The schedule is increased during UAT periods to support testing and validation.

* In **Test (TST)** and **Acceptance (ACC)** environments, orchestration pipelines are typically **run on-demand** for validation and testing.

If a Data Product’s orchestration run takes longer than its scheduled interval, a **concurrency setting of 1** ensures that the next run will wait until the current execution is complete, preventing overlapping or duplicate loads.

---

## DBB Platform Alignment

| DBB Workload | Function of the Orchestration Pipeline |
|--|--|
| **Integration** | Triggers ingestion of mirrored or raw data for the specific Data Product. |
| **Transformation** | Executes dbt-based modeling logic via the generic `transformation_pipeline_DBB`. |
| **Reconciliation** | Runs validation and consistency checks before reporting exposure. |
| **Data Product Refresh** | Updates semantic models with validated data. |

---

## Example: `orchestration_pipeline_GroupFinancialStatements`

For the *Group Financial Statements* Data Product, the orchestration pipeline executes:

1. `integration_pipeline_GroupFinancialStatements`  
2. `transformation_pipeline_DBB`  
3. `reconciliation_pipeline_DBB`  
4. `data_product_refresh_DBB`

This ensures consistent end-to-end processing — from ingestion to semantic model publication — fully aligned with DBB’s modular orchestration standards.