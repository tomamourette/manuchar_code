WITH source_mona_td030i2 AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY LocalPartnerID, ConsoID ORDER BY ConsoID, ODSIngestionDate DESC) AS rn
    FROM {{ source('mona', 'td030i2') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_td030i2
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated