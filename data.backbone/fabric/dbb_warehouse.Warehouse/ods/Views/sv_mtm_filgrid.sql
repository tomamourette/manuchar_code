-- Auto Generated (Do not modify) 2459D294C283AEE8D1B359D7E6CB753B1C92CE6DE65FD58901EDC6F625521C0F
create view "ods"."sv_mtm_filgrid" as WITH source_mtm_filgrid AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY [id] ORDER BY ingestion_timestamp DESC) AS rn
      FROM "dbb_lakehouse"."dbo"."MTM__staging_FILGRID"
),
 
deduplicated AS (
    SELECT *
      FROM source_mtm_filgrid
     WHERE rn = 1
)
 
SELECT *
  FROM deduplicated;