-- Auto Generated (Do not modify) 32D71B0A5BB7BF7F954A0800E2D765FBAE042C870DDFF4A5993D0A644F2F693E
create view "ods"."sv_mona_ts017r2" as WITH source_mona_ts017r2 AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY CurrCode ORDER BY ODSIngestionDate DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Mona__dbo_TS017R2"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_ts017r2
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;