WITH source_mona_ts010s0 AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY AccountID, ConsoID ORDER BY ConsoID, ODSIngestionDate DESC) AS rn
    FROM {{ source('mona', 'ts010s0') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_ts010s0
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated