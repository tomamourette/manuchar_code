-- Auto Generated (Do not modify) 77B0007BDD8093B80201097BA88A7CE01CADB04ACEDBF4A6693F3810D1A7D8BC
create view "ods"."sv_stg_stg_ar_invoices_hist" as WITH source_stg_stg_ar_invoices_hist AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY CustomerID, InvoiceID, Company, ClosureDate ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."STG__val_STG_AR_INVOICES_HIST"
),
 
deduplicated AS (
    SELECT 
        *
    FROM source_stg_stg_ar_invoices_hist
    WHERE rn = 1
)
 
SELECT 
    *
FROM deduplicated;