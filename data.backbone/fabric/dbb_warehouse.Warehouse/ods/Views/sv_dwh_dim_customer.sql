-- Auto Generated (Do not modify) 441D0F4DDDA462764E8D6A1E839AC7B34F323E0679F4CF2254BDE18EE46709F6
create view "ods"."sv_dwh_dim_customer" as WITH source_dwh_dim_customer AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY KDP_SK ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."DWH__dwh_dim_customer"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dwh_dim_customer
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;