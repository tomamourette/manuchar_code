-- Auto Generated (Do not modify) 1C737BA600ACA46ACBC3A75B173C9913C42CF3A896206B356C229F516AF8449A
create view "ods"."sv_mona_ts014c0" as WITH source_mona_ts014c0 AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY CompanyID, ConsoID ORDER BY ConsoID, ODSIngestionDate DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Mona__dbo_TS014C0"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_ts014c0
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;