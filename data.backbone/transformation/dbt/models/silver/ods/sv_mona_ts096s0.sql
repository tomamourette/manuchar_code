WITH source_mona_ts096s0 AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY ConsoID ORDER BY ODSIngestionDate DESC) AS rn
    FROM {{ source('mona', 'ts096s0') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_ts096s0
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated