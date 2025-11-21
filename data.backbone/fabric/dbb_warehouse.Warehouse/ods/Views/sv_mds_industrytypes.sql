-- Auto Generated (Do not modify) CAA2FC3996F32301C5E18890EE497FF7C179435E11EF613921660A8C25437812
create view "ods"."sv_mds_industrytypes" as WITH source_mds_industrytypes AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."MDS__mdm_IndustryTypes"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_industrytypes
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;