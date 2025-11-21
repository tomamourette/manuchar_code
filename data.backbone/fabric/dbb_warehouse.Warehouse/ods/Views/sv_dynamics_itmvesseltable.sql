-- Auto Generated (Do not modify) 985F4D36C9ED8E4E8693F6911FE03045CF39FE5F4059A34C2B77A8B1AA1E16D7
create view "ods"."sv_dynamics_itmvesseltable" as WITH source_dynamics_itmvesseltable AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_itmvesseltable"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_itmvesseltable
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;