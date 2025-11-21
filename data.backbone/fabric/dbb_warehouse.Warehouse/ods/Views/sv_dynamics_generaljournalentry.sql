-- Auto Generated (Do not modify) 41C3701D817313190E772C82B39AC74239EA49114B91324FAA25DAC060FED78A
create view "ods"."sv_dynamics_generaljournalentry" as WITH source_dynamics_generaljournalentry AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_generaljournalentry"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_generaljournalentry
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;