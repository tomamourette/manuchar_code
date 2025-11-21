-- Auto Generated (Do not modify) 63E5011F379507D426E5D738776A8C1DEF0B5D6266479D8AD54E1083BDAF514B
create view "ods"."sv_oil_ref_locations" as WITH source_oil_ref_locations AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY LocationCode, ModifiedDateTime ORDER BY ModifiedDateTime DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."OSS_GenericData__REF_CDS_ManucharLocations"
),

deduplicated AS (
    SELECT 
        *
    FROM source_oil_ref_locations
    WHERE rn = 1
)

SELECT 
    *
FROM deduplicated;