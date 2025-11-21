-- Auto Generated (Do not modify) 08A9098FDD2A8C10632259DBF4BF78B84B0D461D797C3E58B67BE1EE20696531
create view "ods"."sv_mds_accountreporting" as WITH source_mds_accountreporting AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."MDS__mdm_MONA_AccountsReporting"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_accountreporting
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;