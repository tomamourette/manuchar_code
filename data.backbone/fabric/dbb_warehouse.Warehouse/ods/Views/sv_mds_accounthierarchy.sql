-- Auto Generated (Do not modify) D723B044112B8C5BF9990E1D75A1AC7599E9152264216CE2F9676EC65E01C557
create view "ods"."sv_mds_accounthierarchy" as WITH source_mds_accounthierarchy AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code, LastChgDateTime ORDER BY LastChgDateTime DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."MDS__mdm_MONA_AccountHierarchy"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_accounthierarchy
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;