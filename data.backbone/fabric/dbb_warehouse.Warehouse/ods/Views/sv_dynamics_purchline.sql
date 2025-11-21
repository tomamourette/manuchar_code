-- Auto Generated (Do not modify) CB9AE77B9F50B7834B3C444233C3DD5B8FF60C45C6782A386D50D4D8225C6BC7
create view "ods"."sv_dynamics_purchline" as WITH source_dynamics_purchline AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_purchline"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_purchline
    WHERE rn = 1
)

SELECT
    *
FROM deduplicated;