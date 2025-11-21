WITH source_sales_order_dynamics AS (
    SELECT 
        bkey_sales_order_source,
        bkey_sales_order,
        bkey_source,
        valid_from AS ldts,
        CAST('DYNAMICS' AS VARCHAR(25)) AS record_source
    FROM {{ ref('sales_order_dynamics') }}
), 

sources_combined AS (
    SELECT 
        bkey_sales_order_source,
        bkey_sales_order,
        bkey_source,
        ldts,
        record_source
    FROM source_sales_order_dynamics
),

sources_deduplicated AS (
    SELECT 
        bkey_sales_order_source,
        bkey_sales_order,
        bkey_source,
        ldts,
        record_source,
        ROW_NUMBER() OVER (PARTITION BY bkey_sales_order_source ORDER BY ldts ASC) AS row_number
    FROM sources_combined
)

SELECT 
    bkey_sales_order_source,
    bkey_sales_order,
    bkey_source,
    ldts,
    record_source
FROM sources_deduplicated
WHERE row_number = 1