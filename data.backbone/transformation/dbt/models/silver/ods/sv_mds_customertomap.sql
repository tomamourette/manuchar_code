WITH source_mds_customertomap AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM {{ source('mds', 'CustomerToMap') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_customertomap
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated