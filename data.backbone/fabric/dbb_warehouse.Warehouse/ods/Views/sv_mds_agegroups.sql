-- Auto Generated (Do not modify) A71D40CAEF5D012C84A4BB700B5FBCE36970529ACF055DFB17820BCE8DDDD599
create view "ods"."sv_mds_agegroups" as WITH source_mds_agegroups AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."MDS__mdm_AgeGroups"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_agegroups
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;