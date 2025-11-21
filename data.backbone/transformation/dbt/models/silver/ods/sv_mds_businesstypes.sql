WITH source_mds_businesstypes AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM {{ source('mds', 'BusinessType') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_businesstypes
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated