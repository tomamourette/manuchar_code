-- Auto Generated (Do not modify) 14A74A558AB3E9FA9313F71856F3779C155F27ADDCF97C2781CB7B3F38E55D9B
create view "ods"."sv_mds_product" as WITH source_mds_product AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."MDS__mdm_Product"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_product
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;