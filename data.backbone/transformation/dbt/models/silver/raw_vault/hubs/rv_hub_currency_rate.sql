WITH source_currency_rate_mona AS (
    SELECT 
        bkey_currency_rate_source,
        bkey_currency_rate,
        bkey_source,
        valid_from AS ldts,
        CAST('MONA' AS VARCHAR(25)) AS record_source
    FROM {{ ref('currency_rate_mona') }}
),

sources_combined AS (
    SELECT 
        bkey_currency_rate_source,
        bkey_currency_rate,
        bkey_source,
        ldts,
        record_source
    FROM source_currency_rate_mona
), 

sources_deduplicated AS (
    SELECT 
        bkey_currency_rate_source,
        bkey_currency_rate,
        bkey_source,
        ldts,
        record_source,
        ROW_NUMBER() OVER (PARTITION BY bkey_currency_rate_source ORDER BY ldts ASC) AS row_number
    FROM sources_combined
)

SELECT
    bkey_currency_rate_source,
    bkey_currency_rate,
    bkey_source,
    ldts,
    record_source
FROM sources_deduplicated
WHERE row_number = 1