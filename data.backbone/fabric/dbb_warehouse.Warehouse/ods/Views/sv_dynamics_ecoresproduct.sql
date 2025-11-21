-- Auto Generated (Do not modify) E24F09A5A16E052CA2E82C1513C7C963F5361D48DDFEE44CD3CFEFB83E13EA91
create view "ods"."sv_dynamics_ecoresproduct" as WITH source_dynamics_ecoresproduct AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_ecoresproduct"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_ecoresproduct
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;