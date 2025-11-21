-- Auto Generated (Do not modify) F0BAE73BC6CC1C16A7D3E3DE44163A5414EA4B91BD9A79085C3E407DD16E3EEE
create view "ods"."sv_dynamics_vendgroup" as WITH source_dynamics_vendorgroup AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_vendgroup"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_vendorgroup
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;