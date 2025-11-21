-- Auto Generated (Do not modify) 91632DE01BD51119D7ECF1D8130D8483020C29877A1ABCF16B6C8C3C93B29353
create view "ods"."sv_dynamics_custinvoicetrans" as WITH source_dynamics_custinvoicetrans AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_custinvoicetrans"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_custinvoicetrans
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;