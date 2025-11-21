-- Auto Generated (Do not modify) 9ECC5FDF5875A61F405873689D1A67620FBB7D0234D3D5603319980DEF236030
create view "ods"."sv_dynamics_unitofmeasuretranslation" as WITH source_dynamics_unitofmeasuretranslation AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_unitofmeasuretranslation"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_unitofmeasuretranslation
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;