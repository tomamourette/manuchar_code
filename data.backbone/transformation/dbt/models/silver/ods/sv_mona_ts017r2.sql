WITH source_mona_ts017r2 AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY CurrCode ORDER BY ODSIngestionDate DESC) AS rn
    FROM {{ source('mona', 'ts017r2') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_ts017r2
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated