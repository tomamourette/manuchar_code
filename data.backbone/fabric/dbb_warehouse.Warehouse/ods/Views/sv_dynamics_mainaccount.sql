-- Auto Generated (Do not modify) E6BFA49C0A687C71586EBE87089B8FB96A81905E14E862CC5CCA16205CF6FB60
create view "ods"."sv_dynamics_mainaccount" as WITH source_dynamics_mainaccount AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_mainaccount"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_mainaccount
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;