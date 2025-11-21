-- Auto Generated (Do not modify) 03324D3EAE77A7C87BE87B6ADE319541F16F5CF60D7AE598CE4F3112A2E936F6
create view "data_mon"."brg_monitoring_orchestration" as WITH monitoring_orchestration AS (
	SELECT	    

		MIN(job_start_time_utc) AS start_time_utc,
	    MAX(job_end_time_utc) AS end_time_utc,

		item_id AS pipeline_id,
        item_name AS pipeline_name,
		job_instance_id AS pipeline_run_id,
	    CASE WHEN job_status = 'Completed' THEN 'Succeeded' ELSE MAX(job_status) END AS status,
        workspace_id, 
        MAX(workspace_name) AS workspace_name,
        MAX(item_kind) AS item_kind,
        MAX(job_invoke_type) AS job_invoke_type,
        MAX(job_schedule_time_utc) AS job_schedule_time_utc

	FROM "dbb_lakehouse"."dbo"."dbb_orchestration_run_data"
    WHERE job_status IN ('Completed', 'Failed', 'Canceled')
	GROUP BY
		item_id,
		item_name,
		job_instance_id,
	    workspace_id,
	    job_status
)

SELECT 
	*
FROM monitoring_orchestration;