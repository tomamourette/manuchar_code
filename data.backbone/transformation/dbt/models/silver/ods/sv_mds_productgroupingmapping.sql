WITH source_mds_productgroupingmapping AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM {{ source('mds', 'ProductGroupingMapping') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_productgroupingmapping
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated