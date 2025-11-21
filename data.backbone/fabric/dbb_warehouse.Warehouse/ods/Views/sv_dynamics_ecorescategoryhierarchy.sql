-- Auto Generated (Do not modify) 600D1201531BD337EF1B9054E80C088A287FEE1D26F4E734CE23F887CF1CD419
create view "ods"."sv_dynamics_ecorescategoryhierarchy" as WITH source_dynamics_ecorescategoryhierarchy AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_ecorescategoryhierarchy"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_ecorescategoryhierarchy
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;