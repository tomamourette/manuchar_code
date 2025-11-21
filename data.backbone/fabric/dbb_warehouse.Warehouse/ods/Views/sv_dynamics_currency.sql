-- Auto Generated (Do not modify) 4BFAD200701C8907645C4BF3FD3CC8DD27757F0BFA2E640F6342B2BD51E78FAE
create view "ods"."sv_dynamics_currency" as WITH source_dynamics_currency AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_currency"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_currency
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;