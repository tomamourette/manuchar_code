-- Auto Generated (Do not modify) D0D99CCD539BD6E75B42FA2C6EEA0EEBE7A3520B2C686A8C2D9D66D499907809
create view "data_mon"."data_product_refresh" as 

WITH successful_runs AS (
    SELECT
        data_product,
        orchestration_run_id,
        MIN([timestamp]) AS orchestration_start_time,
        MAX([timestamp]) AS orchestration_end_time
    FROM "dbb_warehouse"."meta"."monitoring_integration"
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
);