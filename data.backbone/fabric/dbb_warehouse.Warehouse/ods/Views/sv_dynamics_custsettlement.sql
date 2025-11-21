-- Auto Generated (Do not modify) 319837EB87421B54BBA920892FBE67B4C70C3536B35C719A652CB64E6BB7AE00
create view "ods"."sv_dynamics_custsettlement" as WITH source_dynamics_custsettlement AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_custsettlement"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_custsettlement
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;