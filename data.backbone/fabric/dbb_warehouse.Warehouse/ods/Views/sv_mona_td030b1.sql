-- Auto Generated (Do not modify) D704F7AD4F1FBB6CFA4875FAC35EF558DFD6CE44FE1048331C8745326CE63B92
create view "ods"."sv_mona_td030b1" as WITH source_mona_td030b1 AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY LocalReportedBundleID, ConsoID ORDER BY ODSIngestionDate DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Mona__dbo_TD030B1"
    WHERE ODSActive = 1
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_td030b1
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;