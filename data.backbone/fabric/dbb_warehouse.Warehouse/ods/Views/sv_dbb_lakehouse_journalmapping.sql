-- Auto Generated (Do not modify) 02F95ADE63C6BF17C9F316D52EC4ED8CF163B5EC58FBCBE705C3911531ED2570
create view "ods"."sv_dbb_lakehouse_journalmapping" as WITH source_dbb_lakehouse_journalmapping AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY journal ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."dbb_lakehouse__dbo_enum_JournalMapping"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dbb_lakehouse_journalmapping
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;