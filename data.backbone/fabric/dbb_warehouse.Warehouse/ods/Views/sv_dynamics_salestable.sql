-- Auto Generated (Do not modify) 892540BC2D24B366F8AC2DDD3CE5F1D1076A14A376F434990B14B0F6DA8954D4
create view "ods"."sv_dynamics_salestable" as WITH source_dynamics_salestable AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_salestable"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_salestable
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;