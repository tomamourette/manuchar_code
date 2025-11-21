WITH source_mds_product AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM {{ source('mds', 'Product') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_product
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated