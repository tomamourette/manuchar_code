-- Auto Generated (Do not modify) B834A26AE1174DB0513E2EE62721F5F6E8EC440EE28A08AB0CBB773C6C08DD81
create view "ods"."sv_dynamics_vendinvoicejour" as WITH source_dynamics_vendinvoicejour AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_vendinvoicejour"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_vendinvoicejour
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;