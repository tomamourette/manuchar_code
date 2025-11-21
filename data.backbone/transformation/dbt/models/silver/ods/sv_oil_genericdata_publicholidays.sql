WITH source_oil_genericdata_publicholidays AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY countryOrRegion, [date] ORDER BY countryOrRegion DESC) AS rn
    FROM {{ source('oil_genericdata', 'PublicHolidays') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_oil_genericdata_publicholidays
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated