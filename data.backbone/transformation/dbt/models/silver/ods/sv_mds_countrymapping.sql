WITH source_mds_countrymapping AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM {{ source('mds', 'CountryMapping') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_countrymapping
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated