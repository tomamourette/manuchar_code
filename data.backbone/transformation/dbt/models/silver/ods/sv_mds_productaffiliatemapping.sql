WITH source_mds_productaffiliatemapping AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM {{ source('mds', 'ProductAffiliateMapping') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_productaffiliatemapping
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated