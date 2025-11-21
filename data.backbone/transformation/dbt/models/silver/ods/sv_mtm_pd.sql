WITH source_mtm_pd AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY purchaseOrder_id ORDER BY ingestion_timestamp DESC) AS rn
      FROM {{ source('mtm', 'pd') }}
),
 
deduplicated AS (
    SELECT *
      FROM source_mtm_pd
     WHERE rn = 1
)
 
SELECT *
  FROM deduplicated