WITH source_mds_companymapping AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM {{ source('mds', 'CompanyMapping') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_companymapping
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated