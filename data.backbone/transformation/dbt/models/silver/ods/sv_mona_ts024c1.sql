WITH source_mona_ts024c1 AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY CountryCustomerID ORDER BY ODSIngestionDate DESC) AS rn
    FROM {{ source('mona', 'ts024c1') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_ts024c1
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated