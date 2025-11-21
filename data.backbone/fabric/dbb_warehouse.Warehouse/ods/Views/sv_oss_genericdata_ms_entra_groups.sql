-- Auto Generated (Do not modify) BE68249B4DA99A76E1EBEA95138DCACFF2565E140F7FF0E894BC85C68590D196
create view "ods"."sv_oss_genericdata_ms_entra_groups" as WITH source_oss_generic_ms_entra_groups AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Group_Id ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."OSS_GenericData__REF_Entra_MS_Entra_Groups"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_oss_generic_ms_entra_groups
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;