-- Auto Generated (Do not modify) 60804A3F8B0A0623599496A574893F5D24FE325603832BF1CAA13FC530BAA313
create view "ods"."sv_dbb_lakehouse_consolidationcategorymapping" as WITH source_dbb_lakehouse_consolidationcategorymapping AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY category_mona, version_mona, valid_to ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."dbb_lakehouse__dbo_enum_ConsolidationCategoryMapping"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dbb_lakehouse_consolidationcategorymapping
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;