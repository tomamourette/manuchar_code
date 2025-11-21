WITH source_currency_mds AS (
    SELECT 
        bkey_currency_source,
        bkey_currency,
        bkey_source,
        valid_from AS ldts,
        CAST('MDS' AS VARCHAR(25)) AS record_source
    FROM {{ ref('currency_mds') }}
), 

source_currency_mona AS (
    SELECT 
        bkey_currency_source,
        bkey_currency,
        bkey_source,
        valid_from AS ldts,
        CAST('Mona' AS VARCHAR(25)) AS record_source
    FROM {{ ref('currency_mona') }}
), 

sources_combined AS (
    SELECT 
        bkey_currency_source,
        bkey_currency,
        bkey_source,
        ldts,
        record_source
    FROM source_currency_mds
    UNION
    SELECT 
        bkey_currency_source,
        bkey_currency,
        bkey_source,
        ldts,
        record_source
    FROM source_currency_mona
), 

sources_deduplicated AS (
    SELECT 
        bkey_currency_source,
        bkey_currency,
        bkey_source,
        ldts,
        record_source,
        ROW_NUMBER() OVER (PARTITION BY bkey_currency_source ORDER BY ldts ASC) AS row_number
    FROM sources_combined
)

SELECT
    bkey_currency_source,
    bkey_currency,
    bkey_source,
    ldts,
    record_source
FROM sources_deduplicated
WHERE row_number = 1