-- Auto Generated (Do not modify) B36C9CF988CEDC8E7E23E090A91EE0149CE37F0D43F837AA1BABB355C3860E8B
create view "ods"."sv_dbb_lakehouse_costcenter" as WITH source_dbb_lakehouse_costcenter AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."dbb_lakehouse__dbo_enum_costcenter"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dbb_lakehouse_costcenter
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;