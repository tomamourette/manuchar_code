-- Auto Generated (Do not modify) 6D4308C11462F69EACD99210E485F6EDC9C3000C1A6C24BA5E1C4B88E2A57CA8
create view "ods"."sv_mtm_dim_products" as WITH source_mtm_dim_products AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY ingestion_timestamp DESC) AS rn
      FROM "dbb_lakehouse"."dbo"."MTM__dbo_DIM_Products"
),
 
deduplicated AS (
    SELECT *
      FROM source_mtm_dim_products
     WHERE rn = 1
)
 
SELECT *
  FROM deduplicated;