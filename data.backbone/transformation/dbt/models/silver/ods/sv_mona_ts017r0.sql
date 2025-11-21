WITH source_mona_ts017r0 AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY CurrencyRateID, ConsoID ORDER BY ODSIngestionDate DESC) AS rn
    FROM {{ source('mona', 'ts017r0') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_ts017r0
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated