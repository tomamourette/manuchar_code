-- Auto Generated (Do not modify) B9FABF44423EFD7CD90C9FFD948357A0923B98E309C7C58E8D0D9610CB250DCC
create view "ods"."sv_dynamics_custtable" as WITH source_dynamics_custtable AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_custtable"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_custtable
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;