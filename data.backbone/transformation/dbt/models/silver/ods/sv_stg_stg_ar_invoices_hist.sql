WITH source_stg_stg_ar_invoices_hist AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY CustomerID, InvoiceID, Company, ClosureDate ORDER BY ingestion_timestamp DESC) AS rn
    FROM {{ source('stg', 'stg_ar_invoices_hist') }}
),
 
deduplicated AS (
    SELECT 
        *
    FROM source_stg_stg_ar_invoices_hist
    WHERE rn = 1
)
 
SELECT 
    *
FROM deduplicated