-- Auto Generated (Do not modify) C47E064B7345B58F6C67603B1FE3B7A10E9B88B189D2A120F3430C26053FB820
create view "ods"."sv_mona_td030e2" as WITH source_mona_td030e2 AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY LocalAdjustmentsDetailsID, ConsoID ORDER BY ODSIngestionDate DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Mona__dbo_TD030E2"
    WHERE ODSActive = 1
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_td030e2
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;