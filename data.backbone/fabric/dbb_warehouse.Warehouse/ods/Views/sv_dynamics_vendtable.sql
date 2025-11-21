-- Auto Generated (Do not modify) 260D18B4457BD11C96F0ADB95D09F768DEB108B248230A79326B9BF9C74C7130
create view "ods"."sv_dynamics_vendtable" as WITH source_dynamics_vendortable AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_vendtable"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_vendortable
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;