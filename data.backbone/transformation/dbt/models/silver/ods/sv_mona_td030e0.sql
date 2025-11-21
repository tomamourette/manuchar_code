WITH source_mona_td030e0 AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY LocalAdjustmentsHeaderID, ConsoID ORDER BY ODSIngestionDate DESC) AS rn
    FROM {{ source('mona', 'td030e0') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_td030e0
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated