-- Auto Generated (Do not modify) C983FCD7FBFF43E446D95477906A02923DBB5591177BCFB4A6828BDA96EBD9A6
create view "ods"."sv_dynamics_dirpartytable" as WITH source_dynamics_dirpartytable AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_dirpartytable"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_dirpartytable
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;