-- Auto Generated (Do not modify) FCEC03D8B8DDDB8575177F719E83DB045FC3295EE991BD050655989DB63F97B4
create view "ods"."sv_dynamics_custinvoicejour" as WITH source_dynamics_custinvoicejour AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_custinvoicejour"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_custinvoicejour
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;