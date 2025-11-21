-- Auto Generated (Do not modify) 9E2A1554380CC1FC6C80D6F18E07A03DAB2734B712B435D4C40A330223B1AAFF
create view "ods"."sv_oil_genericdata_ms_entra_groups" as WITH source_oil_generic_ms_entra_groups AS (
    SELECT
        *
    FROM "dbb_lakehouse"."dbo"."OIL_GenericData__MS_Entra_Groups"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_oil_generic_ms_entra_groups
)
 
SELECT
    *
FROM deduplicated;