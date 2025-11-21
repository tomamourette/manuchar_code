-- Auto Generated (Do not modify) F42A3455C86A2BBFA61E64E7123A4A558E78B05682096FC0ABACC3DF213692FB
create view "ods"."sv_dbb_lakehouse_publicholidays" as WITH source_dbb_lakehouse_publicholidays AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY [date] ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."dbb_lakehouse__dbo_enum_PublicHolidays"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dbb_lakehouse_publicholidays
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;