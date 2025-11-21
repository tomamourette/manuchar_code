WITH source_mona_ts098s0 AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY ODSIngestionDate DESC) AS rn
    FROM {{ source('mona', 'ts098s0') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_ts098s0
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated