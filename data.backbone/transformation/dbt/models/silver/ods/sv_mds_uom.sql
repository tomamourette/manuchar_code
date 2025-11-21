WITH source_mds_uom AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM {{ source('mds', 'UOM') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_uom
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated