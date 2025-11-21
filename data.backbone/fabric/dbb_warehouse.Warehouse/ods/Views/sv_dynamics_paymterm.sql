-- Auto Generated (Do not modify) 979D6DB93DB32084B47E79C89F3B37BA83E9618E5B77440D4B76B2746F4F20A3
create view "ods"."sv_dynamics_paymterm" as WITH source_dynamics_paymterm AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_paymterm"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_paymterm
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;