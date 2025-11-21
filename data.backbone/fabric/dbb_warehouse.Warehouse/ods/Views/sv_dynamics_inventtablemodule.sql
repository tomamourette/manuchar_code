-- Auto Generated (Do not modify) E9BFE7905B4727A51E3A1EE797D3DD3960C0A4F78807AAEAAC25FA379974A82F
create view "ods"."sv_dynamics_inventtablemodule" as WITH source_dynamics_inventtablemodule AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_inventtablemodule"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_inventtablemodule
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;