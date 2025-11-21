dbb_lakehouse – Integration Lakehouse
====================================================

Purpose
-------

The `dbb_lakehouse` serves as the raw data integration layer within the Data BackBone (DBB) platform. It is the central landing zone for source data ingested from operational systems through metadata-driven Fabric data pipelines.
This Lakehouse is used in the **integration workload** and is the destination of source-specific pipelines such as `integration_pipeline_source_MDS`, `integration_pipeline_source_Mona`, and others.

Table Storage and Naming
------------------------

Each table is written to the `dbo` schema of the Lakehouse with a naming convention that uniquely identifies the origin:

    dbo.{source_name}__{schema_name}_{table_name}
    

**Example:**

    dbo.MDS__mds_ProductCategory
    

This ensures traceability of all integrated tables and allows for flexible filtering and metadata management across heterogeneous sources.

Metadata-Driven Structure
-------------------------

The ingestion logic for each table is defined via a set of structured files stored in the Lakehouse itself:
*   **CSV – Source List**
    *   File: `integration_source_list.csv`
        
    *   Location: `Files/integration/{source_name}/`
        
    *   Fields include: `table_name`, `schema_name`, `load_enabled`, etc.
        
*   **JSON – Table Metadata**
    *   One JSON file per table, named `{table_name}.json`
        
    *   Location: `Files/integration/{source_name}/{schema_name}/`
        
    *   Contents define:
        *   SQL query for extraction
            
        *   Load type: `FULL` or `INCREMENTAL`
            
        *   Source type
            
This structure allows for full declarative configuration of ingestion logic, making the pipelines fully reusable and scalable.

Process Overview
----------------

1.  Pipeline reads the CSV to find all active tables to load.
    
2.  For each table, it reads the JSON metadata.
    
3.  Executes the source query and writes the result into the Lakehouse.
    
4.  Table is saved in the `dbo` schema with the standardized name.
    
5.  Post-load, the monitoring layer is updated with metadata such as row count, duration, status, etc.
    

Alignment to DBB Workloads
--------------------------

*   **Integration**: This is the primary write target of the integration pipelines.
    
*   **Monitoring**: Tables written here are validated for completeness and freshness via monitoring notebooks.
    

Notes
-----

*   No transformation is applied in this layer; the data is persisted as-is from the source.
    
*   Tables written here serve as the input to the transformation workload executed in the `dbb_warehouse`.