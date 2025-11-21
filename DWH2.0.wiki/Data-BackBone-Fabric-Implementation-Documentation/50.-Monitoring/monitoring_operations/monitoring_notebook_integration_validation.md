Overview of Fabric Notebook for Integration Validation Monitoring
=================================================================

This document describes the structure and role of the Fabric notebook `monitoring_notebook_integration_validation`, which is part of the monitoring workload in the Data BackBone (DBB) platform. The notebook is used to validate the outcomes of data integration processes across the DBB Lakehouse and to log data quality indicators.

Purpose
-------

This notebook was introduced as a direct response to bugs encountered when ingesting and processing Use Case 1 (UC1) data in the Fabric Lakehouse. These issues highlighted the need for automated validation checks that can detect anomalies (such as zero-row tables or missing ingestion timestamps) early in the data pipeline lifecycle.
The notebook is executed after integration to validate ingestion completeness and freshness by scanning all tables in the Lakehouse and logging relevant metadata for monitoring and reporting purposes.

Inputs and Parameters
---------------------

While the notebook does not explicitly use runtime parameters passed from the pipeline, it operates using:
*   The `lakehouse_name` and `warehouse_name` from the environment configuration
    
*   The `workspace` ID for lineage and traceability
    
*   System UTC time for timestamping validation results
    

Core Logic
----------

The notebook performs the following actions:
1.  Connects to the Lakehouse artifact.
    
2.  Queries the `INFORMATION_SCHEMA.TABLES` view to get all table names in the `dbo` schema.
    
3.  For each table:
    *   Executes a query to count the number of rows and retrieve the latest ingestion timestamp.
        
    *   Parses the table name to identify the source system and schema structure.
        
    *   Catches and logs any errors encountered during execution.
        
4.  Writes all results to a Pandas DataFrame for display.
    
5.  Connects to the Fabric Warehouse and writes results to the `meta.monitoring_integration_validation` table.
    
6.  Sends a Teams notification if any tables have 0 rows or failed validation.
    

DBB Platform Workload Alignment
-------------------------------

### Monitoring

*   Performs validation checks across all integrated tables in the Lakehouse.
    
*   Logs row counts and latest ingestion timestamps for each table.
    
*   Flags tables with missing or failed ingestion as part of proactive alerting.
    
*   Sends a notification to a predefined Teams webhook when issues are detected.
    

Output and Impact
-----------------

Upon completion, the notebook:
*   Inserts a record for each validated table into the `meta.monitoring_integration_validation` table
    
*   Includes metrics such as `row_count`, `latest_ingestion_timestamp`, `table_identifier`, and a validation timestamp
    
*   Alerts the data team through Teams if data anomalies are found
    
This notebook significantly enhances DBB’s ability to monitor ingestion quality, especially in complex or multi-source scenarios such as UC1. It ensures that integration issues are identified quickly and consistently across environments.