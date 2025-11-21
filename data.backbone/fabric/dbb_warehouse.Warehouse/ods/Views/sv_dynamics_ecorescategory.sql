-- Auto Generated (Do not modify) 091C4983A305A74330CBB4DE814764C8927EE2D990662BA49863302BC79AEC7C
create view "ods"."sv_dynamics_ecorescategory" as WITH source_dynamics_ecorescategory AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_ecorescategory"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_ecorescategory
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;