-- Auto Generated (Do not modify) 824DC448809FCE04DCC1086AA32352B82C325B294299F3C80E53920C8F954E10
create view "ods"."sv_dynamics_vendinvoicetrans" as WITH source_dynamics_vendinvoicetrans AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_vendinvoicetrans"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_vendinvoicetrans
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;