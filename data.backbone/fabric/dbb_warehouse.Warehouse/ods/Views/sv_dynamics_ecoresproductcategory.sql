-- Auto Generated (Do not modify) 5AD52D746F3B26A265DAAD4DED077054A3C83B1286D662502D5F39FA8CEC1E2C
create view "ods"."sv_dynamics_ecoresproductcategory" as WITH source_dynamics_ecoresproductcategory AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_ecoresproductcategory"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_ecoresproductcategory
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;