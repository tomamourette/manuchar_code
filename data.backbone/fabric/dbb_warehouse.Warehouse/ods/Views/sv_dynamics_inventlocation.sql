-- Auto Generated (Do not modify) 67B33EEB1B70D0A7956865C695F7E773C78DD8CBB128C9B98BA4F849441923CE
create view "ods"."sv_dynamics_inventlocation" as WITH source_dynamics_inventlocation AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_inventlocation"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_inventlocation
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;