-- Auto Generated (Do not modify) FA638880A0D0CA8FC017DB7BD1853FCC7C0C3FCF4B1FCDEAEAD073D43EE1EECC
create view "ods"."sv_mona_ts098s0" as WITH source_mona_ts098s0 AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY ODSIngestionDate DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Mona__dbo_TS098S0"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_ts098s0
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;