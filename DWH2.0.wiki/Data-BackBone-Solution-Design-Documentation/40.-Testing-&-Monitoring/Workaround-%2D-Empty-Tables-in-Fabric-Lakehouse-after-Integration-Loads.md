Workaround Strategy for Empty Tables in Microsoft Fabric via SQL Analytics Endpoint
===================================================================================

Context and Problem Description
-------------------------------

We are currently experiencing an unresolved issue in Microsoft Fabric where tables intermittently return as empty when queried via the **SQL Analytics endpoint**, despite data being visibly present and the copy activity completing successfully. This behavior is **sporadic**, **non-deterministic**, and **not linked to any upstream failure**, making it difficult to detect and handle within standard ETL or dbt logic.

### Key Characteristics of the Bug:

*   Copy activity completes successfully.
    
*   Data is physically present in the Lakehouse Delta files.
    
*   When queried through the SQL Analytics endpoint, the table appears to have **zero rows**.
    
*   Downstream dbt models using these empty tables as sources **do not fail**, but silently return empty result sets.
    
This has a significant impact on downstream data products, particularly in the **Silver layer**, where dependent dbt models generate **empty outputs** without any visible error.

Workaround Strategy
-------------------

To prevent corrupted or incomplete data products due to this issue, we have implemented a **defensive multi-step strategy** that detects, retries, and excludes problematic models when needed. The strategy consists of the following components:

### 1. **Defense 1: Retry on Empty Load**

*   After the table load, immediately query the table via the SQL Analytics endpoint.
    
*   If the table is found to be empty (0 rows), trigger **a single retry**.
    
*   This aims to handle transient issues that resolve with a re-execution.
    

### 2. **Check 1: Identify Persistently Empty Tables**

*   After retry, all tables that remain empty are collected into a list.
    

### 3. **Defense 2: Exclude Models from dbt Run**

*   For each empty table, identify the **dbt models** or **data products** that rely on it as a source.
    
*   These models are dynamically **excluded** from the upcoming dbt run.
    
*   This ensures no empty models are pushed into the Silver layer.
    

### 4. **Monitoring 1: Log Successful Data Products**

*   All dbt models that are executed successfully are logged.
    
*   Logging includes:
    *   Model name
        
    *   Execution timestamp
        
    *   Duration
        
    *   Record count or result size
        
This provides auditability and helps identify models that were **excluded** by absence.

Visual Overview
---------------

::: mermaid
graph LR

  subgraph Defense_1
    A1[Table load] --> A2[Empty check]
    A2 -->|Retry| A1
  end

  subgraph Check_1
    A2 --> B1[List empty tables]
  end

  subgraph Defense_2
    B1 --> C1[Exclude from DBT]
  end

  subgraph Monitoring_1
    C1 --> D1[Log successful data products]
  end

:::
    

Implementation Status and Required Work
---------------------------------------

Below is a breakdown of the current implementation status and what remains to be done for each component:

### Defense 1: Retry on Empty Load

*   The **empty check** logic already exists.
    
*   What still needs to be implemented is the **retry logic**.
    
*   This retry will be built directly into the **integration pipeline**, which already includes the integration validation step corresponding to Defense 1.
    
*   When empty tables are detected, they will be retried **once** via re-execution of the table load.
    

### Check 1: List Empty Tables

*   The logic to identify empty tables is already part of the **integration validation**.
    
*   If no tables are empty, this step is skipped.
    
*   If any retry was triggered, the empty tables will be listed explicitly after the retry concludes.
    

### Defense 2: Exclude Models from dbt Run

*   A dynamic exclusion list must be passed from the **integration pipeline** to the **transformation notebook** responsible for the dbt run.
    
*   What still needs to be implemented:
    *   A **mapping logic** between empty tables and corresponding dbt models.
        
    *   Some **harmonization in the Silver layer** is required to make this mapping possible (e.g., consistent table and model naming).
        
    *   **Granularity determination**: Should exclusions happen at the use case level (i.e., matching semantic models), at the entity level, or across full downstream chains?
        
*   For now, we’ll adopt a use case–level mapping, where all dbt models linked to the impacted use case are excluded from the dbt run.
    

### Monitoring: 1 Log Successful Data Products

*   Logging of dbt model execution is already implemented via the **transformation dbt monitoring**.
    
*   What may still need to be added:
    *   **Tags on dbt models** to make it possible to filter by data product.
        
    *   Enhanced filtering in the dashboard to trace the status and history of models per tagged data product.
        

Key Notes and Best Practices
----------------------------

*   **Retries are limited to one cycle** to avoid masking real persistent issues.
    
*   **Logging is critical** to distinguish between "not executed" and "executed with 0 rows".
    
*   Models excluded from the run should be clearly flagged to facilitate tracking.
    
*   This strategy remains in place until a root-cause fix is provided by Microsoft.
    

Conclusion
----------

This workaround provides a structured way to minimize the business impact of the SQL Analytics endpoint bug while ensuring stability in the downstream Silver layer. It is intentionally modular, so that future changes in Fabric behavior or bug resolution can easily adapt or retire parts of this flow.
    