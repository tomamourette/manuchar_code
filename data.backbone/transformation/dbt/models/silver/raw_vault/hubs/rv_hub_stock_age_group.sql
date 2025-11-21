WITH source_stock_age_group_mds AS (
    SELECT 
        bkey_stock_age_group_source,
        bkey_stock_age_group,
        bkey_source,
        valid_from ldts,
        CAST('MDS' AS VARCHAR(25)) AS record_source
    FROM {{ ref('stock_age_group_mds') }}
), 

sources_combined AS (
    SELECT
        bkey_stock_age_group_source,
        bkey_stock_age_group,
        bkey_source,
        ldts,
        record_source
    FROM source_stock_age_group_mds
), 

sources_deduplicated AS (
    SELECT
        bkey_stock_age_group_source,
        bkey_stock_age_group,
        bkey_source,
        ldts,
        record_source,
        ROW_NUMBER() OVER (PARTITION BY bkey_stock_age_group_source ORDER BY ldts ASC) AS row_number
    FROM sources_combined
)

SELECT 
    bkey_stock_age_group_source,
    bkey_stock_age_group,
    bkey_source,
    ldts,
    record_source
FROM sources_deduplicated
WHERE row_number = 1