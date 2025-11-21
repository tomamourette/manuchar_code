-- Auto Generated (Do not modify) C670A40F54C6CE3F26D4825DE306A7B52FB5E556282F98E306112DAE0D54A253
create view "ods"."sv_dynamics_dimensionattributevaluecombination" as WITH source_dynamics_dimensionattributevaluecombination AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_dimensionattributevaluecombination"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_dimensionattributevaluecombination
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;