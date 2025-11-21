WITH source_invoice_payable_stg AS ( 
    SELECT 
        bkey_invoice_payable_source,
        bkey_invoice_payable,
        bkey_source,
        valid_from AS ldts,
        CAST('STG_AP' AS VARCHAR(25)) AS record_source
    FROM {{ ref('invoice_payable_stg') }}
),

sources_combined AS (
    SELECT 
        bkey_invoice_payable_source,
        bkey_invoice_payable,
        bkey_source,
        ldts,
        record_source
    FROM source_invoice_payable_stg
),

sources_deduplicated AS (
    SELECT 
        bkey_invoice_payable_source,
        bkey_invoice_payable,
        bkey_source,
        ldts,
        record_source,
        ROW_NUMBER() OVER (PARTITION BY bkey_invoice_payable_source ORDER BY ldts ASC) AS row_number
    FROM sources_combined
)

SELECT 
    bkey_invoice_payable_source,
    bkey_invoice_payable,
    bkey_source,
    ldts,
    record_source
FROM sources_deduplicated
WHERE row_number = 1
