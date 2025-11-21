WITH source_mtm_dim_products AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY ingestion_timestamp DESC) AS rn
      FROM {{ source('mtm', 'dim_products') }}
),
 
deduplicated AS (
    SELECT *
      FROM source_mtm_dim_products
     WHERE rn = 1
)
 
SELECT *
  FROM deduplicated