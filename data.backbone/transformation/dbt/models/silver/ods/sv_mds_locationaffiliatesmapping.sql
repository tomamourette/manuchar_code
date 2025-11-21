WITH source_mds_locationaffiliatesmapping AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM {{ source('mds', 'LocationAffiliatesMapping') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_locationaffiliatesmapping
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated