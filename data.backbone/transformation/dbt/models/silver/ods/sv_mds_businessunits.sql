WITH source_mds_businessunits AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM {{ source('mds', 'BusinessUnit') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_businessunits
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated