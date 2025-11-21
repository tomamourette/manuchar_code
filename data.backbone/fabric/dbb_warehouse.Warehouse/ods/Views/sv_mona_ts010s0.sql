-- Auto Generated (Do not modify) 4F4F9A709B0D1E382F21EA599924DBF0B929B9BA05B85E83C7D0CA39BB5FAFC9
create view "ods"."sv_mona_ts010s0" as WITH source_mona_ts010s0 AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY AccountID, ConsoID ORDER BY ConsoID, ODSIngestionDate DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Mona__dbo_TS010S0"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_ts010s0
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;