-- Auto Generated (Do not modify) C4FCE7CB5CF43AE451E0DAE74A1BC49C127DBFF9A150968B1BE4AADE7C1CC8EF
create view "ods"."sv_mona_v_conso_code" as WITH source_mona_v_conso_code AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY ConsoID ORDER BY ODSIngestionDate DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Mona__dbo_V_CONSO_CODE"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_v_conso_code
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;