WITH source_mds_companies AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM {{ source('mds', 'Company') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_companies
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated