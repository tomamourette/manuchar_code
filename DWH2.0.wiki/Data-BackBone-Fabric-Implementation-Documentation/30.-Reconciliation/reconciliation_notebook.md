# reconciliation_notebook

[[_TOC_]]

## Overview

The **`reconciliation_notebook`** is part of the Reconciliation workload in the Data BackBone (DBB) platform.  

It validates the consistency between **source system data** and **transformed DBB outputs** after the transformation pipeline has completed successfully.

This notebook is executed by the [`reconciliation_pipeline_DBB`](/Data-BackBone-Fabric-Implementation-Documentation/30.-Reconciliation/reconciliation_pipeline_DBB), ensuring that critical business KPIs match between upstream sources and their transformed equivalents in the warehouse before data is exposed to reporting or semantic layers.

---

## Purpose

The notebook performs automated reconciliation checks to:

- Verify that KPI values in the **source** and **target (DBB Fact tables)** are aligned.

- Detect potential transformation errors or missing data.

- Prevent publication of inconsistent results by failing the pipeline when discrepancies are detected.

These checks act as the final validation step between the transformation layer and the semantic refresh stage.

---

## Parameters and Configuration

At runtime, the notebook receives its parameters from the [`reconciliation_pipeline_DBB`](/Data-BackBone-Fabric-Implementation-Documentation/30.-Reconciliation/reconciliation_pipeline_DBB), which passes all contextual information as pipeline variables.

  

| Parameter | Description |
|------------|-------------|
| **environment** | Derived from `meta.environments` based on the current Fabric workspace ID; determines the target environment for reconciliation. |
| **data_product** | Parameter passed by the orchestration pipeline. |
| **orchestration_run_id** | Links the reconciliation execution back to the orchestration process for full traceability. |
| **reconciliation_pipeline_run_id** | The unique ID for the current reconciliation notebook execution. Used as the `job_instance_id` in dbt. |
| **reconciliation_pipeline_id** | The static Fabric ID of the reconciliation pipeline. |

---

## Execution Flow
  
### 1. Initialization

- A UTC timestamp (`reconciliation_timestamp`) is generated for traceability.

- The necessary **dbt-fabric** dependencies are installed dynamically.

- Environment credentials are retrieved securely from **Azure Key Vault**, similar to the approach used in the [`transformation_notebook`](/Data-BackBone-Fabric-Implementation-Documentation/20.-Transformation/transformation_notebook).


### 2. Running the dbt Reconciliation Model

The notebook invokes dbt to execute the model **`kpi_reconciliation_history`**, which aggregates and loads KPI comparisons into a dedicated monitoring table.

```bash

dbt run   --target "$environment"   --target-path "../../monitoring/reconciliation_dbt_$reconciliation_timestamp"   --select "kpi_reconciliation_history"   --vars '{"job_instance_id": "'$reconciliation_pipeline_run_id'"}'

```

This dbt model performs **incremental loading** of reconciliation results per run using the `job_instance_id` as the unique key.

---

## Reconciliation Logic

The reconciliation process focuses on comparing **source and target KPI values** at the lowest relevant business granularity.

For the **Group-FinancialStatements** Data Product:

- KPI values from the **MONA source system** are compared to KPI values from the **DBB Fact tables (gold layer)**.

- The comparison is performed at the level of **Company**, **Period**, and **KPI Measure**.

The results are stored in the table:

```

dbb_warehouse.data_mon.kpi_reconciliation_history

```

### Validation Step

After dbt execution, the notebook retrieves the most recent reconciliation results and validates them:

- It groups results per KPI and job run.

- Calculates the difference between the **maximum and minimum KPI amount** across source and target.

- Fails the notebook (and thus the pipeline) if any differences are detected.

Example logic:

```python

if mismatch_count > 0:

    print("❌ Reconciliation check failed!")

    raise Exception(f"Data mismatch detected in {mismatch_count} KPI(s).")

else:

    print("✅ Reconciliation check passed successfully.")

```
Failing the notebook causes the **`reconciliation_pipeline_DBB`** to fail, preventing orchestration from continuing to the next stage (e.g., semantic model refresh).  

This guarantees that only validated and consistent data progresses in the pipeline.

---

## Folder Structure in dbt Project

| Folder | Description |
|---------|--------------|
| **`reconciliation_queries`** | Contains source- and target-specific KPI queries. Each query calculates a KPI value at a monthly level per affiliate. |
| **`reconciliation_results`** | Combines all KPI queries into unified result views. |
| **`reconciliation_history`** | Houses the incremental model (`kpi_reconciliation_history`) that stores aggregated results per reconciliation run. |

All reconciliation models are located under:

```

transformation/dbt/models/gold/reconciliation/

```

---

## Future Enhancements

- Implement threshold-based validation logic (e.g., allowable KPI variance ranges).

- Extend reconciliation coverage to other Data Products such as **Group-SalesAndMargin**.

- Integrate automatic pipeline failure thresholds to fully automate quality gating before semantic refresh.

---

## Output and Impact

Upon completion:

- All reconciliation results are written to `dbb_warehouse.data_mon.kpi_reconciliation_history`.

- Any mismatches between source and DBB outputs are surfaced and logged.

- If discrepancies are found, the notebook fails and halts subsequent orchestration steps.

- Successful runs confirm data accuracy and integrity across layers.

This reconciliation process enforces **data trust, accuracy, and governance** within the DBB platform, ensuring that reported KPIs faithfully reflect source system truth.