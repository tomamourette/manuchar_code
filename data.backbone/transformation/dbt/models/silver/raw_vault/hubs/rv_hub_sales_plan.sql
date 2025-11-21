WITH source_sales_plan_dwh AS ( 
    SELECT 
        bkey_sales_plan_source,
        bkey_sales_plan,
        bkey_source,
        valid_from AS ldts,
        CAST('DWH' AS VARCHAR(25)) AS record_source
    FROM {{ ref('sales_plan_dwh') }}
), 

sources_combined AS (
    SELECT 
        bkey_sales_plan_source,
        bkey_sales_plan,
        bkey_source,
        ldts,
        record_source
    FROM source_sales_plan_dwh
),

sources_deduplicated AS (
    SELECT 
        bkey_sales_plan_source,
        bkey_sales_plan,
        bkey_source,
        ldts,
        record_source,
        ROW_NUMBER() OVER (PARTITION BY bkey_sales_plan_source ORDER BY ldts ASC) AS row_number
    FROM sources_combined
)

SELECT 
    bkey_sales_plan_source,
    bkey_sales_plan,
    bkey_source,
    ldts,
    record_source
FROM sources_deduplicated
WHERE row_number = 1;
