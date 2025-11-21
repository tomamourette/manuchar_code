WITH source_mtm_fil AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY [id] ORDER BY ingestion_timestamp DESC) AS rn
      FROM {{ source('mtm', 'fil') }}
),
 
deduplicated AS (
    SELECT *
      FROM source_mtm_fil
     WHERE rn = 1
)
 
SELECT *
  FROM deduplicated