-- Auto Generated (Do not modify) 7829209DEF9FA4AAB15D0584464889201B2CC69C50A60E326B0EFA9FB88A861C
create view "ods"."sv_mona_ts096s0" as WITH source_mona_ts096s0 AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY ConsoID ORDER BY ODSIngestionDate DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Mona__dbo_TS096S0"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_ts096s0
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;