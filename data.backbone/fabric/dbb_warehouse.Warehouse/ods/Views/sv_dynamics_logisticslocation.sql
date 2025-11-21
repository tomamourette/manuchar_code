-- Auto Generated (Do not modify) 47255F3552EB290531A4C6909802BEC1CE1D66A9C3CF33605CA4739EE23E84D6
create view "ods"."sv_dynamics_logisticslocation" as WITH source_dynamics_logisticslocation AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_logisticslocation"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_logisticslocation
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;