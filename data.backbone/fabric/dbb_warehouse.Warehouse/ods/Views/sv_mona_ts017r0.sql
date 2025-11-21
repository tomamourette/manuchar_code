-- Auto Generated (Do not modify) EBCB74499DC34961FE075ADB013D7F7531F19A32463FCAABED5B5EE282645E87
create view "ods"."sv_mona_ts017r0" as WITH source_mona_ts017r0 AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY CurrencyRateID, ConsoID ORDER BY ODSIngestionDate DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Mona__dbo_TS017R0"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_ts017r0
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;