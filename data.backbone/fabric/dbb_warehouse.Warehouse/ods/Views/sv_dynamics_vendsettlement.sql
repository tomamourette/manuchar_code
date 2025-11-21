-- Auto Generated (Do not modify) DCC636431A6FF673DC03EBA35BAD627D346C0DA56BE2C5893743749FE4ABD2CD
create view "ods"."sv_dynamics_vendsettlement" as WITH source_dynamics_vendsettlement AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
      FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_vendsettlement"
),
 
deduplicated AS (
    SELECT *
      FROM source_dynamics_vendsettlement
     WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;