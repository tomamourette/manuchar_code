WITH source_stock_stg AS (
    SELECT 
        bkey_stock_source,
        bkey_stock,
        bkey_source,
        valid_from AS ldts,
        CAST('STG_STOCK' AS VARCHAR(25)) AS record_source
    FROM {{ ref('stock_stg') }}
), 

source_stock_dyn AS (
    SELECT 
        bkey_stock_source,
        bkey_stock,
        bkey_source,
        valid_from AS ldts,
        CAST('DYNAMICS' AS VARCHAR(25)) AS record_source
    FROM {{ ref('stock_dynamics') }}
),

sources_combined AS (
    SELECT 
        bkey_stock_source,
        bkey_stock,
        bkey_source,
        ldts,
        record_source
    FROM source_stock_stg

    UNION ALL

    SELECT 
        bkey_stock_source,
        bkey_stock,
        bkey_source,
        ldts,
        record_source
    FROM source_stock_dyn
),

sources_deduplicated AS (
    SELECT 
        bkey_stock_source,
        bkey_stock,
        bkey_source,
        ldts,
        record_source,
        ROW_NUMBER() OVER (PARTITION BY bkey_stock_source ORDER BY ldts ASC) AS row_number
    FROM sources_combined
)

SELECT 
    bkey_stock_source,
    bkey_stock,
    bkey_source,
    ldts,
    record_source
FROM sources_deduplicated
WHERE row_number = 1;
