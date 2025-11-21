WITH source_purchase_invoice_dynamics AS ( 
    SELECT 
        bkey_purchase_invoice_source,
        bkey_purchase_invoice,
        bkey_source,
        valid_from AS ldts,
        CAST('DYNAMICS' AS VARCHAR(25)) AS record_source
    FROM {{ ref('purchase_invoice_dynamics') }}
),

sources_combined AS (
    SELECT 
        bkey_purchase_invoice_source,
        bkey_purchase_invoice,
        bkey_source,
        ldts,
        record_source
    FROM source_purchase_invoice_dynamics
),

sources_deduplicated AS (
    SELECT 
        bkey_purchase_invoice_source,
        bkey_purchase_invoice,
        bkey_source,
        ldts,
        record_source,
        ROW_NUMBER() OVER (PARTITION BY bkey_purchase_invoice_source ORDER BY ldts ASC) AS row_number
    FROM sources_combined
)

SELECT 
    bkey_purchase_invoice_source,
    bkey_purchase_invoice,
    bkey_source,
    ldts,
    record_source
FROM sources_deduplicated
WHERE row_number = 1
