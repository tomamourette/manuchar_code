-- Auto Generated (Do not modify) 5489D60C11AD5DBE6F068C08101343B00AFD5AB6DA6D69C6DAAD15A0C5C04A32
create view "ods"."sv_oss_genericdata_ms_entra_group_members" as WITH source_site_oss_genericdata_ms_entra_group_members AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY userPrincipalName, groupID ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."OSS_GenericData__REF_Entra_MS_Entra_GroupMembers"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_site_oss_genericdata_ms_entra_group_members
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;