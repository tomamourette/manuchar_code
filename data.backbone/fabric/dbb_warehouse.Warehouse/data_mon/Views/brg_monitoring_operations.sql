-- Auto Generated (Do not modify) 8FD775A1BDF652A224EF5D3E8E2B355496F6205953AE70D64BF6DF1D431906BA
create view "data_mon"."brg_monitoring_operations" as WITH monitoring_integration AS (
	SELECT
		-- Date Keys
	    MIN([timestamp]) AS start_time,
	    DATEADD(SECOND, -MAX(duration), MIN([timestamp])) AS end_time,
	    
		integration_pipeline_id AS pipeline_id,
		orchestration_run_id,
		integration_pipeline_source_run_id AS pipeline_run_id,
	    'Integration' AS operation,
	    status,
	    data_product,
	    source_name,
	    schema_name,
	    table_name,
		NULL AS dbt_model,
	    load_type,
	    MAX(duration) AS duration,
	    MAX(rows_read) AS rows_read,
	    MAX(rows_written) AS rows_written,
	    MAX(throughput) AS throughput,
	    NULL AS failures,
	    NULL AS adapter_message,
		NULL AS build_models,
		NULL AS reconciliation_source,
		NULL AS kpi_name,
        NULL AS amount
	FROM "dbb_warehouse"."meta"."monitoring_integration"
	WHERE orchestration_run_id <> ''
	GROUP BY
		integration_pipeline_id,
	    orchestration_run_id,
		integration_pipeline_source_run_id,
	    data_product,
	    source_name,
	    schema_name,
	    table_name,
	    load_type,
	    workspace,
	    status
),

monitoring_transformation_dbt AS (
	SELECT
		-- Date Keys
	    MIN(process_started_at) AS start_time,
	    MAX(process_completed_at) AS end_time,

		transformation_pipeline_id AS pipeline_id,
		orchestration_run_id,
		transformation_pipeline_run_id AS pipeline_run_id,
	    'Transformation' AS operation,
	   	CASE WHEN status = 'success' THEN 'Succeeded' ELSE status END AS status,
	    data_product,
	   	NULL AS source_name,
	    NULL AS schema_name,
	    NULL AS table_name,
	    item_name AS dbt_model,
	    NULL AS load_type,
	    MAX(duration) AS duration,
	    NULL AS rows_read,
	    MAX(rows_affected) AS rows_written,
	    NULL AS throughput,
	    MAX(failures) AS failures,
	    MAX(adapter_message) AS adapter_message,
		MAX(build_models) AS build_models,
		NULL AS reconciliation_source,
		NULL AS kpi_name,
        NULL AS amount
	FROM "dbb_warehouse"."meta"."monitoring_transformation_dbt"
	WHERE process_stage = 'execute'
	GROUP BY
		transformation_pipeline_id,
	    orchestration_run_id,
		transformation_pipeline_run_id,
	    data_product,
	    environment,
	    item_name,
	    status
),

monitoring_reconciliation AS (
    SELECT
        NULL AS start_time,
        NULL AS end_time,

        NULL AS pipeline_id,
        orchestration_run_id,
        reconciliation_pipeline_run_id AS pipeline_run_id,
        'Reconciliation' AS operation,
        NULL AS status,
        data_product,
        NULL AS source_name,
        NULL AS schema_name,
        NULL AS table_name,
        NULL AS dbt_model,
        NULL AS load_type,
        NULL AS duration,
        NULL AS rows_read,
        NULL AS rows_written,
        NULL AS throughput,
        NULL AS failures,
        NULL AS adapter_message,
        NULL AS build_models,
        source_name AS reconciliation_source,
		kpi_name,
        amount
    FROM "dbb_warehouse"."data_mon"."kpi_reconciliation_history"
),

monitoring_semantic_model_refresh AS (
	SELECT	    
		-- Date Keys
		MIN(process_started_at) AS start_time,
	    MAX(process_completed_at) AS end_time,

		data_product_refresh_pipeline_id AS pipeline_id,
		orchestration_run_id,
		data_product_refresh_pipeline_run_id AS pipeline_run_id,
	    'Semantic Model Refresh' AS operation,
	    CASE WHEN status = 'Completed' THEN 'Succeeded' ELSE MAX(status) END AS status,
	    data_product,
	    NULL AS source_name,
	    NULL AS schema_name,
	    NULL AS table_name,
		NULL AS dbt_model,
	    NULL AS load_type,
	    MAX(duration) AS duration,
	    NULL AS rows_read,
	    NULL AS rows_written,
	    NULL AS throughput,
	    NULL AS failures,
	    NULL AS adapter_message,
		NULL AS build_models,
		NULL AS reconciliation_source,
		NULL AS kpi_name,
        NULL AS amount
	FROM "dbb_warehouse"."meta"."monitoring_semantic_model_refresh"
	GROUP BY
		data_product_refresh_pipeline_id,
	    orchestration_run_id,
		data_product_refresh_pipeline_run_id,
	    data_product,
	    workspace_id,
	    status
)

-- Fact 
SELECT * FROM monitoring_integration
UNION ALL
SELECT * FROM monitoring_transformation_dbt
UNION ALL
SELECT * FROM monitoring_reconciliation
UNION ALL
SELECT * FROM monitoring_semantic_model_refresh;