-- Auto Generated (Do not modify) 8020B907BCB0B2AF6B14D003CB68694E033BC1F0E77551BDD0D912D315F9CAC8
create view "ods"."sv_mona_ts024c0" as WITH source_mona_ts024c0 AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY CountryCode ORDER BY ODSIngestionDate DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Mona__dbo_TS024C0"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_ts024c0
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;