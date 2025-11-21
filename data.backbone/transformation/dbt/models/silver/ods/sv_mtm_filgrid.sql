WITH source_mtm_filgrid AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY [id] ORDER BY ingestion_timestamp DESC) AS rn
      FROM {{ source('mtm', 'filgrid') }}
),
 
deduplicated AS (
    SELECT *
      FROM source_mtm_filgrid
     WHERE rn = 1
)
 
SELECT *
  FROM deduplicated