WITH source_mona_ts024c0 AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY CountryCode ORDER BY ODSIngestionDate DESC) AS rn
    FROM {{ source('mona', 'ts024c0') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_ts024c0
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated