-- Auto Generated (Do not modify) 15DFF06B6317FA1206C99ABEDFD5579BC8E341884E0ADC2F0DFBAB96A9E9F0BB
create view "ods"."sv_dynamics_salesline" as WITH source_dynamics_salesline AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_salesline"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_salesline
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;