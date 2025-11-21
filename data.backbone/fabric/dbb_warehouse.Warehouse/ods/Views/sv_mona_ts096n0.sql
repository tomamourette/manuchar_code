-- Auto Generated (Do not modify) EA7A3033072F5F2CC361543E3D9E9C111908AAA0374BA122FDF58F5CDBCBBB15
create view "ods"."sv_mona_ts096n0" as WITH source_mona_ts096n0 AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY CategoryID ORDER BY ODSIngestionDate DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Mona__dbo_TS096N0"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_ts096n0
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;