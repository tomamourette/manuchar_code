-- Auto Generated (Do not modify) D29193AFC633B4366B48C631C0BCD3D4607CBEFF3098CFB15383BCB836964611
create view "ods"."sv_mds_countrymapping" as WITH source_mds_countrymapping AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."MDS__mdm_CountryMapping"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_countrymapping
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;