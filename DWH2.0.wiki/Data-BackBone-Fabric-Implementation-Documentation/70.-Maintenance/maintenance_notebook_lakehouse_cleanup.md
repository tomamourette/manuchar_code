Overview of Fabric Notebook for Lakehouse Cleanup
=================================================

This document outlines the design and purpose of the Fabric notebook `maintenance_notebook_lakehouse_cleanup`, part of the maintenance workload in the Data BackBone (DBB) platform. The notebook is responsible for executing cleanup operations against tables in the Fabric Lakehouse.

Purpose
-------

This notebook is used to clean up temporary or obsolete data in the Lakehouse. It is typically run after large-scale ingestion tests, development cycles, or other non-production operations that leave behind unnecessary tables or data partitions.
The cleanup process helps maintain a clean and controlled environment, reducing storage usage and preventing stale data from being mistakenly used by downstream logic.

Parameters and Inputs
---------------------

This notebook does not use pipeline parameters or dynamic runtime inputs. It executes predefined SQL statements against known objects in the Lakehouse.

Core Logic
----------

The notebook performs direct SQL-based cleanup actions including:
*   `DELETE` statements to remove rows from selected tables
    
*   `DROP TABLE` commands to fully remove obsolete Lakehouse tables
    
The specific tables and conditions are defined within the notebook and may be updated as DBB cleanup requirements evolve.

DBB Platform Workload Alignment
-------------------------------

### Maintenance

*   Removes unused or temporary data from the Lakehouse
    
*   Helps reduce clutter in shared environments (e.g. TST, ACC)
    
*   Prepares the environment for controlled development, QA, or refresh cycles
    

Output and Impact
-----------------

This notebook does not generate logs or write to monitoring tables, but it directly affects the state of the Lakehouse by:
*   Deleting rows from tables where appropriate
    
*   Dropping tables that are no longer needed
    
This task ensures that DBB Lakehouse artifacts remain clean, consistent, and free of residual test data that could interfere with production reporting or validation logic.