WITH source_mds_locations AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM {{ source('mds', 'Location') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_locations
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated