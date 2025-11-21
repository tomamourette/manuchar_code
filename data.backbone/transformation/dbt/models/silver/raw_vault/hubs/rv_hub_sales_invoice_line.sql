WITH source_sales_invoice_line_dynamics AS ( 
    SELECT 
        bkey_sales_invoice_line_source,
        bkey_sales_invoice_line,
        bkey_source,
        valid_from AS ldts,
        CAST('DYNAMICS' AS VARCHAR(25)) AS record_source
    FROM {{ ref('sales_invoice_line_dynamics') }}
), 

source_sales_invoice_line_stg_sales AS (
    SELECT 
        bkey_sales_invoice_line_source,
        bkey_sales_invoice_line,
        bkey_source,
        valid_from AS ldts,
        CAST('STG_SALES' AS VARCHAR(25)) AS record_source
    FROM {{ ref('sales_invoice_line_stg_sales') }}
),

sources_combined AS (
    SELECT 
        bkey_sales_invoice_line_source,
        bkey_sales_invoice_line,
        bkey_source,
        ldts,
        record_source
    FROM source_sales_invoice_line_dynamics

    UNION ALL

    SELECT 
        bkey_sales_invoice_line_source,
        bkey_sales_invoice_line,
        bkey_source,
        ldts,
        record_source
    FROM source_sales_invoice_line_stg_sales
),

sources_deduplicated AS (
    SELECT 
        bkey_sales_invoice_line_source,
        bkey_sales_invoice_line,
        bkey_source,
        ldts,
        record_source,
        ROW_NUMBER() OVER (PARTITION BY bkey_sales_invoice_line_source ORDER BY ldts ASC) AS row_number
    FROM sources_combined
)

SELECT 
    bkey_sales_invoice_line_source,
    bkey_sales_invoice_line,
    bkey_source,
    ldts,
    record_source
FROM sources_deduplicated
WHERE row_number = 1
