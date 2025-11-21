-- Auto Generated (Do not modify) D50A27DAD949BA7FC989CBA165B0F775EC7D6DCDC5B78FD6BF27738937603E12
create view "ods"."sv_mds_accountheaders" as WITH source_mds_accountheaders AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code, LastChgDateTime ORDER BY LastChgDateTime DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."MDS__mdm_MONA_AccountHeaders"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_accountheaders
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;