WITH source_mds_countries AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM {{ source('mds', 'Country') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_countries
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated