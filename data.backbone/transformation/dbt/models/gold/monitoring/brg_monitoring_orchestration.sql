WITH orchestration_base AS (
    SELECT
        item_id              AS pipeline_id,
        item_name            AS pipeline_name,
        job_instance_id      AS pipeline_run_id,
        workspace_id,
        workspace_name,
        item_kind,
        job_invoke_type,
        job_schedule_time_utc,
        job_status,
        job_start_time_utc,
        job_end_time_utc
    FROM {{ source('monitoring_orchestration', 'DbbOrchestrationRunData') }}
    WHERE job_status IN ('NotStarted', 'InProgress', 'Failed', 'Completed', 'Canceled')
),
runs AS (
    SELECT
        pipeline_id,
        pipeline_name,
        pipeline_run_id,
        workspace_id,
        workspace_name,
        item_kind,
        job_invoke_type,
        job_schedule_time_utc,
        job_status,
        job_start_time_utc,
        job_end_time_utc,

        -- overall run start/end
        MIN(job_start_time_utc) OVER (
            PARTITION BY pipeline_id, pipeline_run_id, workspace_id
        ) AS start_time_utc,

        MAX(job_end_time_utc) OVER (
            PARTITION BY pipeline_id, pipeline_run_id, workspace_id
        ) AS end_time_utc,

        -- pick the latest status per run
        ROW_NUMBER() OVER (
            PARTITION BY pipeline_id, pipeline_run_id, workspace_id
            ORDER BY COALESCE(job_end_time_utc, job_start_time_utc) DESC
        ) AS rn
    FROM orchestration_base
)

SELECT
    start_time_utc,
    end_time_utc,
    pipeline_id,
    pipeline_name,
    pipeline_run_id,
    CASE 
        WHEN job_status = 'Completed' THEN 'Succeeded'
        ELSE job_status
    END AS status,
    workspace_id,
    workspace_name,
    item_kind,
    job_invoke_type,
    job_schedule_time_utc
FROM runs
WHERE rn = 1;