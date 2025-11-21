-- Auto Generated (Do not modify) 5AC359E291DAAB52AB445E2EF818AA82D9DCA2202416C7912EA50E2AB9F68046
create view "ods"."sv_dynamics_purchtable" as WITH source_dynamics_purchtable AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_purchtable"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_purchtable
    WHERE rn = 1
)

SELECT
    *
FROM deduplicated;