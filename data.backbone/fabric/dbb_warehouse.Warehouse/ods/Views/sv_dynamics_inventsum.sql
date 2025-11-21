-- Auto Generated (Do not modify) 2B37DA3E1EFE4DB2230B5739747C3D8F3841597FF66051E09DA1FC26571B6481
create view "ods"."sv_dynamics_inventsum" as WITH source_dynamics_inventsum AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_inventsum"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_inventsum
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;