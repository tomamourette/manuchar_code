-- Auto Generated (Do not modify) 352FE93221FDE3CA6C176334398CCBBC2E06356DD0038584FE73FB424C57348C
create view "ods"."sv_oil_genericdata_dates" as WITH source_oil_genericdata_dates AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY date_key ORDER BY date_key DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."OIL_GenericData__Manuchar_Dates"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_oil_genericdata_dates
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;