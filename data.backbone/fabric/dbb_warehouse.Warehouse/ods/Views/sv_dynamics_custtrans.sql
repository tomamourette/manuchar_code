-- Auto Generated (Do not modify) 0C97CA5F49E2403B3367A95CD37B541BCCDB6D0215980A3179F36255F1A3831B
create view "ods"."sv_dynamics_custtrans" as WITH source_dynamics_custtrans AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_custtrans"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_custtrans
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;