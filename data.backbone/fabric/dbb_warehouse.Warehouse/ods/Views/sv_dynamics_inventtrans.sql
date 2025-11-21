-- Auto Generated (Do not modify) 0254A79FF09BE09B8C691ECF5DD22990604409F0BA8340E27346ADC266EF5F2F
create view "ods"."sv_dynamics_inventtrans" as WITH source_dynamics_inventtrans AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_inventtrans"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_inventtrans
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;