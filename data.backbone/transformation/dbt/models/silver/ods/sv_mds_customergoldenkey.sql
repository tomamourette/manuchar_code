WITH source_mds_customergoldenkey AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM {{ source('mds', 'CustomerGoldenKey') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_customergoldenkey
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated