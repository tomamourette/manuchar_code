WITH source_date_oil_genericdata AS (
    SELECT 
        bkey_date_source,
        bkey_date,
        bkey_source,
        CAST(date AS DATETIME2(6)) AS ldts,
        CAST('DBB Lakehouse' AS VARCHAR(25)) AS record_source
    FROM {{ ref('date_oil_genericdata') }}
), 

sources_combined AS (
    SELECT 
        bkey_date_source,
        bkey_date,
        bkey_source,
        ldts,
        record_source
    FROM source_date_oil_genericdata
), 

sources_deduplicated AS (
    SELECT 
        bkey_date_source,
        bkey_date,
        bkey_source,
        ldts,
        record_source,
        ROW_NUMBER() OVER (PARTITION BY bkey_date_source ORDER BY ldts ASC) AS row_number
    FROM sources_combined
)

SELECT 
    bkey_date_source,
    bkey_date,
    bkey_source,
    ldts,
    record_source
FROM sources_deduplicated
WHERE row_number = 1