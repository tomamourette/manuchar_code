-- Auto Generated (Do not modify) 5A2C41EFE84B5BB8BE5E03B3A266869D437DB5F139FAD5C3B2176158E57C1D80
create view "ods"."sv_dynamics_custgroup" as WITH source_dynamics_custgroup AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_custgroup"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_custgroup
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;