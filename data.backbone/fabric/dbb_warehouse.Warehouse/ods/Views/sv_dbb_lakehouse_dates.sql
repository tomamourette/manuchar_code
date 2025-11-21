-- Auto Generated (Do not modify) 99B1DEA93486FB4DA5F0270421CA9A3B2D5AEF65EB682479A50959D06A30123D
create view "ods"."sv_dbb_lakehouse_dates" as WITH source_dbb_lakehouse_dates AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY date_key ORDER BY [ingestion_timestamp] DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."dbb_lakehouse__dbo_enum_dates"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dbb_lakehouse_dates
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;