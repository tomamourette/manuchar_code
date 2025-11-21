-- Auto Generated (Do not modify) BDEF560C5F621180D429E9F0EF8A87BC12A9C828D1B5D5EFE2E938CC45AD6B8C
create view "ods"."sv_mds_uommapping" as WITH source_mds_uommapping AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."MDS__mdm_UOMMapping"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_uommapping
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;