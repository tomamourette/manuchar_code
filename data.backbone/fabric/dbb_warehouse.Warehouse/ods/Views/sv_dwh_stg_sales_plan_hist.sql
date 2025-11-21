-- Auto Generated (Do not modify) 6D2C0E66EF682C594CA84712D3E7EC635737D5BA53A03F0398C13E7A99A9EFD6
create view "ods"."sv_dwh_stg_sales_plan_hist" as WITH source_stg_stg_sales_plan_hist AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY ID ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."DWH__ds_STG_val_STG_SALES_PLAN_HIST"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_stg_stg_sales_plan_hist
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;