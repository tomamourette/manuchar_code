Overview of Fabric Notebook for Transformation Monitoring
=========================================================

This document describes the structure and function of the Fabric notebook `monitoring_notebook_transformation`, which is part of the monitoring workload in the Data BackBone (DBB) platform. The notebook is used to capture execution metrics from transformation pipelines and log them for traceability and platform observability.

Purpose
-------

The notebook is triggered at the end of a transformation pipeline (e.g. `transformation_pipeline_UC1`) to record the status and operational metadata of the notebook execution. It supports monitoring efforts by storing structured metrics that provide insight into processing performance and stability.

Inputs and Parameters
---------------------

Although the notebook does not explicitly use the parameterization functions within the visible code, it is invoked by the pipeline with the following parameters passed in context:
*   `workspace`: Workspace ID from which the pipeline was triggered
    
*   `status`: The status of the executed transformation (e.g. `Succeeded`, `Failed`)
    
*   `duration`: Total runtime of the transformation notebook in seconds
    
*   `pool_id`: Identifier of the Spark pool used during execution
    
*   `session_id`: Spark session ID for the executed job
    
*   `run_id`: Internal Fabric run ID for tracking
    
*   `message`: Any status message or error description returned by the transformation notebook
    
These are expected to be passed from the pipeline and cast to appropriate types within the notebook before writing.

Core Logic
----------

The notebook performs the following actions:
1.  Captures the current UTC timestamp.
    
2.  Connects to the Fabric Warehouse `dbb_warehouse` using the `workspace` context.
    
3.  Prepares and executes an `INSERT` statement into the `meta.monitoring_transformation` table.
    
4.  Logs whether the operation was successful or failed.
    
The captured metrics enable centralized tracking of Spark job executions within DBB.

DBB Platform Workload Alignment
-------------------------------

### Monitoring

*   Records runtime metadata for transformation executions
    
*   Logs job status, Spark resource usage, and context identifiers
    
*   Provides traceability and audit logs for completed transformation workloads
    

Output and Impact
-----------------

After execution, the notebook inserts a monitoring record into the `meta.monitoring_transformation` table, which includes:
*   Status and duration of the transformation
    
*   Spark execution metadata (session, pool, run ID)
    
*   Timestamp of monitoring entry
    
*   Workspace context and status messages
    
This notebook provides critical operational telemetry for DBB transformations and supports platform monitoring through consistent logging of notebook-level performance.