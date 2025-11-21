WITH source_mds_productgrouping AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM {{ source('mds', 'ProductGrouping') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_productgrouping
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated