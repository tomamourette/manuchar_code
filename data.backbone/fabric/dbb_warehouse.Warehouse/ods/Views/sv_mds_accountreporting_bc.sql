-- Auto Generated (Do not modify) 08A9098FDD2A8C10632259DBF4BF78B84B0D461D797C3E58B67BE1EE20696531
create view "ods"."sv_mds_accountreporting_bc" as 
WITH source_mds_accountreporting AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code, LastChgDateTime ORDER BY LastChgDateTime DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."MDS__mdm_MONA_AccountsReporting"
    where LastChgDateTime <= '2025-09-03 12:21:20.716667'
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