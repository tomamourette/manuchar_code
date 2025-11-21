-- Auto Generated (Do not modify) F76974CE77ECD582459D4BB6214AAB2B49F2BA6F15A67FCFD1CBF728B7981412
create view "ods"."sv_mona_ts014m1" as WITH source_mona_ts014m1 AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY AddInfoCompanyID, ConsoID ORDER BY ConsoID, ODSIngestionDate DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Mona__dbo_TS014M1"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_ts014m1
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;