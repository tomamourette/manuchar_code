-- Dim Pipeline
WITH source_data AS (
SELECT
    pipeline_name,
    pipeline_id,

    -- Reporting name
    CASE 
        WHEN pipeline_name = 'orchestration_pipeline_Group-FinancialStatements' 
            THEN 'Job-Orchestration - E2E for Financial Statements'
        WHEN pipeline_name = 'integration_pipeline_source_MDS' 
            THEN 'Job-Step – Integration Onprem-MDS'
        WHEN pipeline_name = 'integration_pipeline_source_dbb_lakehouse' 
            THEN 'Job-Step – Integration DBB Lakehouse'
        WHEN pipeline_name = 'MonaOnPrem_MainPipeline' 
            THEN 'Job-Step – Integration Onprem-MonaConso to OIL'
        WHEN pipeline_name = 'integration_pipeline_source_Mona' 
            THEN 'Job-Step – Integration Onprem-MonaConso to OIL'
        WHEN pipeline_name = 'transformation_pipeline_DBB' 
            THEN 'Job-Step – Transformation for DBB'
        WHEN pipeline_name = 'reconciliation_pipeline_DBB' 
            THEN 'Job-Step – Reconciliation (Source2target)'
        WHEN pipeline_name = 'data_product_refresh_DBB' 
            THEN 'Job-Step – DataProduct refresh'
        ELSE pipeline_name
    END AS pipeline_report_name,
    
    -- Pipeline Hierarchy
    CASE
        WHEN LOWER(pipeline_name) LIKE '%orchestration%' THEN 'Parent'
        ELSE 'Child'
    END AS pipeline_hierarchy,

    workspace_id,
    workspace_name,

    MIN(start_time_utc) AS first_run_utc,
    MAX(end_time_utc) AS last_run_utc

FROM {{ ref('brg_monitoring_orchestration') }}
GROUP BY
    pipeline_name,
    pipeline_id,
    workspace_id,
    workspace_name
),

dim_pipeline AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY pipeline_id) AS tkey_pipeline,
        pipeline_id AS bkey_pipeline,
        pipeline_id,
		workspace_id,
        workspace_name,
        pipeline_name,
        pipeline_report_name,
        pipeline_hierarchy,
        CAST(first_run_utc AS datetime2(6)) AS first_run_utc,
        CAST(last_run_utc AS datetime2(6)) AS last_run_utc
    FROM source_data
)

SELECT *
FROM dim_pipeline

