-- Auto Generated (Do not modify) 1EF870D0459ABEF81B57E51149B7843B426D09ECCAE278755DD18D68EB357C21
create view "ods"."sv_oil_genericdata_sites" as WITH source_oil_genericdata_site AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY SiteCode ORDER BY ModifiedDateTime DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."OIL_GenericData__Manuchar_Sites"
),

deduplicated AS (
    SELECT
        *
    FROM source_oil_genericdata_site
    WHERE rn = 1
)

SELECT
    *
FROM deduplicated;