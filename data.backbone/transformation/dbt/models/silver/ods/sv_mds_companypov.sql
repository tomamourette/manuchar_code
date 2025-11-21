WITH source_mds_companypov AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM {{ source('mds', 'CompanyPOV') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_companypov
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated