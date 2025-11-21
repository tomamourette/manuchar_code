WITH source_mona_td030e2 AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY LocalAdjustmentsDetailsID, ConsoID ORDER BY ODSIngestionDate DESC) AS rn
    FROM {{ source('mona', 'td030e2') }}
    WHERE ODSActive = 1
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_td030e2
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated