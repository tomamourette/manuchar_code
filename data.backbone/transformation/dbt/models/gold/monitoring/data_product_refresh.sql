{{ config(
    tags=['Group-FinancialStatements', 'Monitoring', 'Data Product Refresh'],
    materialized='view'
) }}

WITH successful_runs AS (
    SELECT
        data_product,
        orchestration_run_id,
        MIN([timestamp]) AS orchestration_start_time,
        MAX([timestamp]) AS orchestration_end_time
    FROM {{ source('monitoring_operations', 'MonitoringIntegration') }}
    GROUP BY
        data_product,
        orchestration_run_id
    HAVING SUM(CASE WHEN status = 'Failed' THEN 1 ELSE 0 END) = 0
)
SELECT *
FROM successful_runs sr
WHERE orchestration_end_time = (
    SELECT MAX(orchestration_end_time)
    FROM successful_runs
    WHERE data_product = sr.data_product
)    