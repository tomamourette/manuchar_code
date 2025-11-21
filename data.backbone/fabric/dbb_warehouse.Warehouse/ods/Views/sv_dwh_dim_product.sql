-- Auto Generated (Do not modify) E37BC8D15DBF29E43E6C5384ADD944E7057AE472F9EC48843FC3DD6D290C6B2F
create view "ods"."sv_dwh_dim_product" as WITH source_dwh_dim_product AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY KDP_SK ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."DWH__dwh_dim_product"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dwh_dim_product
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;