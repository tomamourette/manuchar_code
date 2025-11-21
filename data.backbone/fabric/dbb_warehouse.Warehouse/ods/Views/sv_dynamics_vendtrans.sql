-- Auto Generated (Do not modify) 41C43AD17B9CF925B1E13236716D1C5D5D4D3842525AFB87F02D2B74E03F895F
create view "ods"."sv_dynamics_vendtrans" as WITH source_dynamics_vendtrans AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_vendtrans"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_vendtrans
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;