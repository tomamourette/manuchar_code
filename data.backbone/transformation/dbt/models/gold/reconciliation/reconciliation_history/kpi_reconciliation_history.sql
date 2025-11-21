{{ config(
    materialized='incremental'
) }}

WITH kpi_history AS (
    SELECT
        ROUND(SUM(amount), 0) AS amount,
        source_name,
        kpi_name,
        '{{ var("reconciliation_pipeline_run_id", "unknown") }}' AS reconciliation_pipeline_run_id,
        '{{ var("orchestration_run_id", "unknown") }}' AS orchestration_run_id,
        '{{ var("data_product", "unknown") }}' AS data_product,
        CAST(GETDATE() AS DATETIME2(6)) AS reconciliation_timestamp
    
    FROM {{ ref('kpi_reconciliation')}}
    GROUP BY
        source_name,
        kpi_name
)

SELECT
    *
FROM kpi_history

{% if is_incremental() %}
WHERE reconciliation_pipeline_run_id NOT IN (SELECT DISTINCT reconciliation_pipeline_run_id FROM {{ this }})
{% endif %}