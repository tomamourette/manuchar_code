-- Auto Generated (Do not modify) 033CA040B44407868475B040B977BAFDEA7561BD7B827668B8D7AD5BC3D8ED02
create view "ods"."sv_dynamics_dimensionattributevalueset" as WITH source_dynamics_dimensionattributevalueset AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_dimensionattributevalueset"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_dimensionattributevalueset
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;