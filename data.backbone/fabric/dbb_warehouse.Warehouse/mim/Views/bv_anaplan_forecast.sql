-- Auto Generated (Do not modify) 536E016ED5519CB78BE568F0E5493B3B196797C31BC99A4B50B64F12E58E324E
create view "mim"."bv_anaplan_forecast" as -- ===============================
-- STEP 1: Extracting Entity Data
-- From Different Sources in a Single CTE
-- ===============================

WITH source_anaplan_forecast AS (
    SELECT
        sat.tkey_forecast_transaction,
        hub.bkey_forecast_transaction,
        hub.bkey_source,
        sat.sales_amount_group_currency,
        sat.quantity_in_metric_ton,
        sat.cogs_group_currency,
        sat.cogs2_group_currency,
        sat.gross_profit_group_currency,
        sat.home_currency,
        sat.plan_rate,
        sat.valid_from,
        sat.valid_to
    FROM "dbb_warehouse"."mim"."rv_hub_anaplan_forecast" hub
    LEFT JOIN "dbb_warehouse"."mim"."rv_sat_anaplan_forecast" sat ON hub.bkey_forecast_transaction_source = sat.bkey_forecast_transaction_source
    WHERE sat.is_current = 1 -- add only the latest version
),

-- ===============================
-- STEP 2: Generating Non-overlapping 
-- Time Ranges for Each bkey
-- ===============================

time_ranges AS (
    SELECT
        bkey_forecast_transaction,
        CAST(time_event AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(time_event) OVER (PARTITION BY bkey_forecast_transaction ORDER BY time_event), '2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_forecast_transaction, valid_from AS time_event FROM source_anaplan_forecast
        UNION 
        SELECT bkey_forecast_transaction, valid_to AS time_event FROM source_anaplan_forecast
    ) AS time_events
    WHERE time_event <> '2999-12-31 23:59:59.999999'
)

-- ===============================
-- STEP 3: Combine Everything into a Timeline
-- Take One Leading Source for Each Attribute
-- ===============================

SELECT
    boomi.tkey_forecast_transaction,
    tr.bkey_forecast_transaction,
    boomi.sales_amount_group_currency,
    boomi.quantity_in_metric_ton,
    boomi.cogs_group_currency,
    boomi.cogs2_group_currency,
    boomi.gross_profit_group_currency,
    boomi.home_currency,
    boomi.plan_rate,
    tr.valid_from,
    tr.valid_to,
    CASE
        WHEN tr.valid_to = CAST('2999-12-31 23:59:59.999999' AS DATETIME2(6)) THEN 1
        ELSE 0
    END AS is_current
FROM time_ranges tr

LEFT JOIN source_anaplan_forecast boomi
    ON boomi.bkey_forecast_transaction = tr.bkey_forecast_transaction
    AND boomi.valid_from <= tr.valid_from 
    AND COALESCE(boomi.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
    AND boomi.bkey_source = 'BOOMI' -- add only the source specific bkey's;