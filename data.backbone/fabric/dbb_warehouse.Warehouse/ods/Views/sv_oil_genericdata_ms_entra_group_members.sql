-- Auto Generated (Do not modify) 901B60478BFBFF5F3EE70295F89B81FE2B45649753429C18BF963A4D4AA1B05F
create view "ods"."sv_oil_genericdata_ms_entra_group_members" as WITH source_site_oil_genericdata_ms_entra_group_members AS (
    SELECT
        *
    FROM "dbb_lakehouse"."dbo"."OIL_GenericData__MS_Entra_GroupMembers"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_site_oil_genericdata_ms_entra_group_members
)
 
SELECT
    *
FROM deduplicated;