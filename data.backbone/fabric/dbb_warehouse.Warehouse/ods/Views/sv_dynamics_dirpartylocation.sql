-- Auto Generated (Do not modify) D0678DB1BE600EAB3EC55C181C349B92BCCC6AE756A1D36928497AF07BD93326
create view "ods"."sv_dynamics_dirpartylocation" as WITH source_dynamics_dirpartylocation AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_dirpartylocation"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_dirpartylocation
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;