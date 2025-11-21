WITH source_mds_uommapping AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM {{ source('mds', 'UOMMapping') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_uommapping
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated