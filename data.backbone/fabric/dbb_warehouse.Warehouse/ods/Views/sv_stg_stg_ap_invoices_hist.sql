-- Auto Generated (Do not modify) 3D9BA46D27F2C1508112BBE03E48162216E221002695117B1A300B4D0F165F2A
create view "ods"."sv_stg_stg_ap_invoices_hist" as WITH source_stg_stg_ap_invoices_hist AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY SupplierID, InvoiceID, Company, ClosureDate ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."STG__val_STG_AP_INVOICES_HIST"
),
 
deduplicated AS (
    SELECT 
        *
    FROM source_stg_stg_ap_invoices_hist
    WHERE rn = 1
)
 
SELECT 
    *
FROM deduplicated;