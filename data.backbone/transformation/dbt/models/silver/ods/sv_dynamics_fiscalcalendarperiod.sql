WITH source_dynamics_fiscalcalendarperiod AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'FiscalCalendarPeriods') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_fiscalcalendarperiod
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

