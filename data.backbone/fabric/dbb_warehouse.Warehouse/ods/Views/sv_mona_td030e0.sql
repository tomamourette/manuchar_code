-- Auto Generated (Do not modify) CA5A2CF44248130CCFE79B72A95CA3BD0DFCA6F2881195B60AF6EB5C33F11095
create view "ods"."sv_mona_td030e0" as WITH source_mona_td030e0 AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY LocalAdjustmentsHeaderID, ConsoID ORDER BY ODSIngestionDate DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Mona__dbo_TD030E0"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_td030e0
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;