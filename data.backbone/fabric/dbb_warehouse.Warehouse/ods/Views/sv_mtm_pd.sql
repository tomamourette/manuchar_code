-- Auto Generated (Do not modify) 4F7F3844776B7BAD9122190353D759F2AC009EFE258FE8287AAD9C31068383CC
create view "ods"."sv_mtm_pd" as WITH source_mtm_pd AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY purchaseOrder_id ORDER BY ingestion_timestamp DESC) AS rn
      FROM "dbb_lakehouse"."dbo"."MTM__staging_PD"
),
 
deduplicated AS (
    SELECT *
      FROM source_mtm_pd
     WHERE rn = 1
)
 
SELECT *
  FROM deduplicated;