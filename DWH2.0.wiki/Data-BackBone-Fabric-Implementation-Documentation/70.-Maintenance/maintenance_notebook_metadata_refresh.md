Overview of Fabric Notebook for Metadata Refresh
================================================

This document outlines the structure and role of the Fabric notebook `maintenance_notebook_metadata_refresh`, which belongs to the maintenance workload within the Data BackBone (DBB) platform. The notebook is responsible for refreshing metadata associated with Delta tables in Fabric Lakehouse and Warehouse artifacts.

Purpose
-------

This notebook was created in response to a critical issue encountered while processing Use Case 1 (UC1), where Copy Data activities completed successfully, but the Delta metadata for certain Lakehouse tables remained unavailable or inaccessible. This led to downstream failures in data transformation and reporting steps.
The notebook was introduced to proactively trigger metadata refreshes on affected artifacts to ensure data availability and consistent discoverability across the DBB platform.

Parameters and Inputs
---------------------

The notebook is intended to be invoked by a pipeline and uses the following variables internally or passed from the pipeline context:
*   `workspace_id`: The Fabric workspace containing the artifact
    
*   `artifact_id`: ID of the Lakehouse or Warehouse to refresh
    
*   `artifact_type`: Either `lakehouses` or `warehouses`, which determines the type of metadata refresh command to issue
    
These are used to build the correct API call to Microsoft Fabric's metadata refresh service.

Core Logic
----------

The notebook performs the following steps:
1.  Validates the `artifact_type` and sets the appropriate Fabric REST API path
    
2.  Constructs a command payload to refresh metadata
    *   `MetadataRefreshExternalCommand` for Lakehouses
        
    *   `MetadataRefreshCommand` for Warehouses
        
3.  Resolves the SQL endpoint associated with the artifact
    
4.  Uses the `fabric.FabricRestClient()` to call the API and execute the metadata refresh
    
5.  Handles invalid artifact types explicitly with error handling
    

DBB Platform Workload Alignment
-------------------------------

### Maintenance

*   Forces a metadata refresh of SQL endpoints on Lakehouse and Warehouse artifacts
    
*   Ensures newly ingested tables and schema updates are visible to downstream consumers
    
*   Prevents metadata inconsistencies from propagating through the DBB pipeline architecture
    

Output and Impact
-----------------

Once completed, the notebook ensures that:
*   Delta tables created or modified by Copy Data activities are visible and accessible
    
*   Metadata is up-to-date for transformation, monitoring, and reporting workloads
    
*   Workflows depending on refreshed metadata no longer fail due to missing schema definitions
    
This notebook plays a critical role in stabilizing the metadata layer across Fabric artifacts, especially in the wake of issues encountered during UC1 ingestion. It is designed for use in both scheduled and reactive maintenance workflows across environments.