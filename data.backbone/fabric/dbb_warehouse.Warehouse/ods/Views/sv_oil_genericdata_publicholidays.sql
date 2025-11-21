-- Auto Generated (Do not modify) 6FB86B2FF9CE3783FEDF910DC255F6A1BB5BC6932C5CBDC241927F38AA1CF174
create view "ods"."sv_oil_genericdata_publicholidays" as WITH source_oil_genericdata_publicholidays AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY countryOrRegion, [date] ORDER BY countryOrRegion DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."OIL_GenericData__Manuchar_PublicHolidays"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_oil_genericdata_publicholidays
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;