WITH source_oil_genericdata_dates AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY date_key ORDER BY date_key DESC) AS rn
    FROM {{ source('oil_genericdata', 'Date') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_oil_genericdata_dates
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated