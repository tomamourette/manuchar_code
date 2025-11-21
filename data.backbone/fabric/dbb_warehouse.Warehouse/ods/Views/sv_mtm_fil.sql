-- Auto Generated (Do not modify) 0D2FF80020789282CC15BFAC793BEBFE1A00505FD8E21B3F8C131C669ED43601
create view "ods"."sv_mtm_fil" as WITH source_mtm_fil AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY [id] ORDER BY ingestion_timestamp DESC) AS rn
      FROM "dbb_lakehouse"."dbo"."MTM__staging_FIL"
),
 
deduplicated AS (
    SELECT *
      FROM source_mtm_fil
     WHERE rn = 1
)
 
SELECT *
  FROM deduplicated;