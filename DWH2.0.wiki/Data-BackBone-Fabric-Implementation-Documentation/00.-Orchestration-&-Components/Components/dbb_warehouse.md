dbb_warehouse – Transformation Warehouse
=======================================================

Purpose
-------

The `dbb_warehouse` is the central transformation layer within the Data BackBone (DBB) platform. It is built using dbt (Data Build Tool) and serves as the structured, performance-optimized storage for modeled data. This warehouse forms the **silver** and **gold** layers in the DBB medallion architecture.
It is used in the **transformation workload**, where business logic is applied to raw ingested tables to generate curated outputs for reporting, analytics, and semantic models.

Data Modeling Approach
----------------------

All transformations in the `dbb_warehouse` are governed using a Fabric-hosted dbt project. The dbt structure follows DBB’s enterprise vault modeling pattern:

### Layer Structure

*   **source_views**: Thin views on top of Lakehouse tables for dbt source declarations
    
*   **raw_vault**: Contains technical satellite and hub models that apply SCD and hash logic
    
*   **business_vault**: Contains enriched and integrated models combining multiple sources
    
*   **presentation**: Dimensional models and fact tables ready for reporting
    
This structure ensures clean separation of technical ingestion, business logic, and reporting requirements.

Execution
---------

Transformations are triggered using the `transformation_notebook_DBB`, which receives the following parameters:
*   `models`: dbt selector tag/string (e.g. `+tag:Group-FinancialStatements`)
    
*   `environment`: tst, acc, qual or prd – used to control the dbt target profile
    
The notebook runs `dbt deps` and `dbt build` commands to execute the selected models. Results are written to the `dbb_warehouse` using the dbt `target-path`, with monitoring artifacts stored separately for review.

Monitoring and Logging
----------------------

After transformation runs:
*   The `monitoring_notebook_transformation` captures metadata (duration, status, Spark session, etc.) and logs it to the `meta.monitoring_transformation` table.
    
*   This allows full traceability and historical tracking of model executions.
    

Alignment to DBB Workloads
--------------------------

*   **Transformation**: Primary destination of all business and technical dbt models
    
*   **Monitoring**: Post-run statistics and results logged automatically
    

Notes
-----

*   Only curated, structured, and validated outputs are stored in this warehouse.
    
*   The `dbb_warehouse` is connected to Power BI datasets and supports semantic model refresh automation from Fabric pipelines.
    
*   All models follow Kimball-aligned and enterprise vault best practices.
    
This component is essential to turning raw source data into governed, analytics-ready outputs in DBB.