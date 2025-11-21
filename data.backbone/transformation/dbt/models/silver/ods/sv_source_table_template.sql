{{ config(
  enabled=false
) }}

WITH source_/*<<source_name>>_<<table_name>>*/ AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY /*<<primary_key_field>>*/ ORDER BY /*<<ingestion_timestamp_field>>*/ DESC) AS rn
      FROM {{ source('source', 'table') }}
),
 
deduplicated AS (
    SELECT *
      FROM source_/*<<source_name>>_<<table_name>>*/
     WHERE rn = 1
)
 
SELECT *
  FROM deduplicated