-- Auto Generated (Do not modify) D619C5268CC7D40910FA5478A7F6E55932906A6CF17DB44F3446C6710FB0743A
create view "ods"."sv_oil_genericdata_locations" as WITH source_site_oil_genericdata_locations AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY LocationCode ORDER BY ModifiedDateTime DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."OIL_GenericData__Manuchar_Locations"
),

deduplicated AS (
    SELECT 
        *
    FROM source_site_oil_genericdata_locations
    WHERE rn = 1
)

SELECT 
    *
FROM deduplicated;