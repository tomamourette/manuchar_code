WITH source_stg_stg_sales_plan_hist AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY ID ORDER BY ingestion_timestamp DESC) AS rn
    FROM {{ source('dwh', 'stg_sales_plan_hist') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_stg_stg_sales_plan_hist
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated