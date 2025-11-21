WITH source_mds_customermapping AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM {{ source('mds', 'CustomerMapping') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_customermapping
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated