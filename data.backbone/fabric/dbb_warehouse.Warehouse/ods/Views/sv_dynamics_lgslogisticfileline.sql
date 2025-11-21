-- Auto Generated (Do not modify) 351CB4FD1ABED733B560224F0B34AFCBCF8763046992C4D64518D326DA5E0096
create view "ods"."sv_dynamics_lgslogisticfileline" as WITH source_dynamics_lgslogisticfileline AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_lgslogisticfileline"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_lgslogisticfileline
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;