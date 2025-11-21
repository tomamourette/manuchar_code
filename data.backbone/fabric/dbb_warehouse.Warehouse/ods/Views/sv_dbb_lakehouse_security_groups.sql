-- Auto Generated (Do not modify) BE68249B4DA99A76E1EBEA95138DCACFF2565E140F7FF0E894BC85C68590D196
create view "ods"."sv_dbb_lakehouse_security_groups" as WITH source_dbb_lakehouse_security_groups AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Group_Id, ingestion_timestamp ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."dbb_lakehouse__dbo_enum_security_groups"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dbb_lakehouse_security_groups
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;