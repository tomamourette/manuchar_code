-- Auto Generated (Do not modify) AD4D3A5EA922E7A0A062DF3FAC2436DE9D60FD83CABB7C1CE1B9BA217040189B
create view "ods"."sv_dynamics_lgslogisticfiletable" as WITH source_dynamics_lgslogisticfiletable AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_lgslogisticfiletable"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_lgslogisticfiletable
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;