WITH source_mds_currencies AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM {{ source('mds', 'Currency') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_currencies
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated