-- Auto Generated (Do not modify) 6BA7AD12C9EBB43F2A3B8B744D60B537EEF41B8A06BC8A67040C7C633716D6F0
create view "ods"."sv_dynamics_fiscalcalendarperiod" as WITH source_dynamics_fiscalcalendarperiod AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Dynamics__dbo_fiscalcalendarperiod"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_fiscalcalendarperiod
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;