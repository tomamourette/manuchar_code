-- Auto Generated (Do not modify) B109CF10886BFED44FF00DD70D47EE58E54492D1E59E2A22F237901346A68ECF
create view "ods"."sv_oil_ref_sites" as WITH source_oil_ref_site AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY SiteCode, ModifiedDateTime ORDER BY ModifiedDateTime DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."OSS_GenericData__REF_CDS_ManucharSites"
),

deduplicated AS (
    SELECT
        *
    FROM source_oil_ref_site
    WHERE rn = 1
)

SELECT
    *
FROM deduplicated;