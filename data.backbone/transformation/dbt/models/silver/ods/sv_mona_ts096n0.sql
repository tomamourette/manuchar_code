WITH source_mona_ts096n0 AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY CategoryID ORDER BY ODSIngestionDate DESC) AS rn
    FROM {{ source('mona', 'ts096n0') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_ts096n0
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated