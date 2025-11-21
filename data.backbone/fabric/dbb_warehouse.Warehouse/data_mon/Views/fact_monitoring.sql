-- Auto Generated (Do not modify) CD3B48C12A6876B44D8C37B0CED54EF0323D81BC3783322B2AF856091C3C123C
create view "data_mon"."fact_monitoring" as -- Fact Monitoring
WITH monitoring_orchestration AS (
    SELECT
        pipeline_id,
        pipeline_name,
        pipeline_run_id,
        status AS pipeline_status,
        start_time_utc AS pipeline_start_time_utc,
        end_time_utc AS pipeline_end_time_utc,
        job_schedule_time_utc AS pipeline_scheduled_time_utc
    FROM "dbb_warehouse"."data_mon"."brg_monitoring_orchestration"
),

monitoring_operations AS (
    SELECT
        pipeline_id,
        orchestration_run_id, -- <-- parent run id
        pipeline_run_id, -- <-- child run id
        operation,
        status AS operation_status,
        data_product,
        source_name AS integration_source_name,
        schema_name AS integration_schema_name,
        table_name AS integration_table_name,
        load_type AS integration_load_type,
        rows_read AS integration_rows_read,
        rows_written AS integration_rows_written,
        build_models AS transformation_build_models,
        dbt_model AS transformation_dbt_model,
        reconciliation_source,
		kpi_name AS reconciliation_kpi_name,
        amount AS reconciliation_amount,
        duration AS operation_duration,
        start_time AS operation_start_time_utc,
        end_time AS operation_end_time_utc
    FROM "dbb_warehouse"."data_mon"."brg_monitoring_operations"
),

fact_monitoring AS (
    SELECT
        -- Pipeline details
        mor.pipeline_id AS bkey_pipeline, -- child pipeline id
        mor.pipeline_run_id,
        mor.pipeline_status,
        mor.pipeline_start_time_utc,
        mor.pipeline_end_time_utc,
        mor.pipeline_scheduled_time_utc,

        -- Orchestration / operation details
        mop.orchestration_run_id, -- parent run id
        mop.operation,
        mop.operation_status,
        mop.operation_start_time_utc,
        mop.operation_end_time_utc,
        mop.operation_duration,

        -- Integration operation
        mop.integration_source_name,
        mop.integration_schema_name,
        mop.integration_table_name,
        mop.integration_load_type,
        mop.integration_rows_read,
        mop.integration_rows_written,

        -- Transformation operation
        mop.transformation_dbt_model,
        mop.transformation_build_models,

        -- Reconciliation operation
        mop.reconciliation_source,
        mop.reconciliation_kpi_name,
        mop.reconciliation_amount,

        -- Semantic model refresh operation
        mop.data_product

    FROM monitoring_orchestration AS mor
    LEFT JOIN monitoring_operations AS mop
        ON mor.pipeline_run_id = mop.pipeline_run_id
),

-- Resolve the parent pipeline_id from the parent run id
parent_pipeline AS (
    SELECT
        fm.orchestration_run_id,
        parent_mor.pipeline_id AS parent_bkey_pipeline  -- <-- parent pipeline_id
    FROM fact_monitoring fm
    LEFT JOIN monitoring_orchestration parent_mor
      ON fm.orchestration_run_id = parent_mor.pipeline_run_id
  	GROUP BY 
  		fm.orchestration_run_id,
        parent_mor.pipeline_id
)

SELECT
    child_dim.tkey_pipeline AS tkey_child_pipeline,   -- child key
    parent_dim.tkey_pipeline AS tkey_parent_pipeline,  -- parent key (nullable)
    fm.pipeline_run_id,
    fm.pipeline_status,
    fm.pipeline_start_time_utc,
    fm.pipeline_end_time_utc,
    fm.pipeline_scheduled_time_utc,
    fm.orchestration_run_id,
    fm.operation,
    fm.operation_status,
    fm.operation_start_time_utc,
    fm.operation_end_time_utc,
    fm.operation_duration,
    fm.integration_source_name,
    fm.integration_schema_name,
    fm.integration_table_name,
    fm.integration_load_type,
    fm.integration_rows_read,
    fm.integration_rows_written,
    fm.transformation_dbt_model,
    fm.transformation_build_models,
    fm.reconciliation_source,
    fm.reconciliation_kpi_name,
    fm.reconciliation_amount,
    fm.data_product
FROM fact_monitoring fm
LEFT JOIN "dbb_warehouse"."data_mon"."dim_pipeline" AS child_dim
  ON child_dim.bkey_pipeline = fm.bkey_pipeline
LEFT JOIN parent_pipeline pp
  ON pp.orchestration_run_id = fm.orchestration_run_id
LEFT JOIN "dbb_warehouse"."data_mon"."dim_pipeline" AS parent_dim
  ON parent_dim.bkey_pipeline = pp.parent_bkey_pipeline;;