-- ===============================
-- STEP 1: Extracting Entity Data
-- From Different Sources in a Single CTE
-- ===============================

WITH source_currency_rate AS (
    SELECT
        hub.bkey_currency_rate,
        hub.bkey_source,
        sat.currency_rate_consolidation_id,
        sat.currency_rate_consolidation_code,
        sat.currency_rate_currency_code,
        sat.currency_rate_reference_currency_code,
        sat.currency_rate_closing_rate,
        sat.currency_rate_average_rate,
        sat.currency_rate_average_month,
        sat.currency_rate_budget_closing_rate,
        sat.currency_rate_budget_average_rate,
        sat.currency_rate_budget_average_month,
        sat.currency_rate_month,
        sat.currency_rate_year,
        sat.currency_rate_closing_date,
        sat.valid_from,
        sat.valid_to
    FROM {{ ref('rv_hub_currency_rate')}} hub
    LEFT JOIN {{ ref('rv_sat_currency_rate')}} sat ON hub.bkey_currency_rate_source = sat.bkey_currency_rate_source
    WHERE sat.is_current = 1 -- add only the latest version
),

-- ===============================
-- STEP 2: Generating Non-overlapping 
-- Time Ranges for Each bkey
-- ===============================

time_ranges AS (
    SELECT
        bkey_currency_rate,
        CAST(time_event AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(time_event) OVER (PARTITION BY bkey_currency_rate ORDER BY time_event), '2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_currency_rate, valid_from AS time_event FROM source_currency_rate
        UNION 
        SELECT bkey_currency_rate, valid_to AS time_event FROM source_currency_rate
    ) AS time_events
    WHERE time_event <> '2999-12-31 23:59:59.999999'
)

-- ===============================
-- STEP 3: Combine Everything into a Timeline
-- Take One Leading Source for Each Attribute
-- ===============================

SELECT
    tr.bkey_currency_rate,
    mona.currency_rate_consolidation_id,
    mona.currency_rate_consolidation_code,
    mona.currency_rate_currency_code,
    mona.currency_rate_reference_currency_code,
    mona.currency_rate_closing_rate,
    mona.currency_rate_average_rate,
    mona.currency_rate_average_month,
    mona.currency_rate_budget_closing_rate,
    mona.currency_rate_budget_average_rate,
    mona.currency_rate_budget_average_month,
    mona.currency_rate_year,
    mona.currency_rate_month,
    mona.currency_rate_closing_date,
    tr.valid_from,
    tr.valid_to,
    CASE
        WHEN tr.valid_to = CAST('2999-12-31 23:59:59.999999' AS DATETIME2(6)) THEN 1
        ELSE 0
    END AS is_current
FROM time_ranges tr

LEFT JOIN source_currency_rate mona
    ON mona.bkey_currency_rate = tr.bkey_currency_rate
    AND mona.valid_from <= tr.valid_from 
    AND COALESCE(mona.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
    AND mona.bkey_source = 'MONA' -- add only the source specific bkey's