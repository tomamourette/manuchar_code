-- Auto Generated (Do not modify) 95B8C76C130A0DF966E0873A0B18CDE3176F9C0EFF49189A29B5F99D36477293
create view "data_mon"."dim_pipeline" as -- Dim Pipeline
WITH source_data AS (
    SELECT
        pipeline_name,
        pipeline_id,
		workspace_id,
        workspace_name,
        -- Optional: get first/latest start/end time per pipeline
        MIN(start_time_utc) AS first_run_utc,
        MAX(end_time_utc) AS last_run_utc
    FROM "dbb_warehouse"."data_mon"."brg_monitoring_orchestration"
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
        first_run_utc,
        last_run_utc
    FROM source_data
)

SELECT *
FROM dim_pipeline;