-- Auto Generated (Do not modify) A92DE022B9F93D23D2A7BF3454188C4E12672C9BD43258DEC665B68A76257E74
create view "mim"."bv_anaplan_budget" as -- ===============================
-- STEP 1: Extracting Entity Data
-- From Different Sources in a Single CTE
-- ===============================

WITH source_anaplan_budget AS (
    SELECT
        sat.tkey_budget_transaction,
        hub.bkey_budget_transaction,
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
    FROM "dbb_warehouse"."mim"."rv_hub_anaplan_budget" hub
    LEFT JOIN "dbb_warehouse"."mim"."rv_sat_anaplan_budget" sat ON hub.bkey_budget_transaction_source = sat.bkey_budget_transaction_source
    WHERE sat.is_current = 1 -- add only the latest version
),

-- ===============================
-- STEP 2: Generating Non-overlapping 
-- Time Ranges for Each bkey
-- ===============================

time_ranges AS (
    SELECT
        bkey_budget_transaction,
        CAST(time_event AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(time_event) OVER (PARTITION BY bkey_budget_transaction ORDER BY time_event), '2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_budget_transaction, valid_from AS time_event FROM source_anaplan_budget
        UNION 
        SELECT bkey_budget_transaction, valid_to AS time_event FROM source_anaplan_budget
    ) AS time_events
    WHERE time_event <> '2999-12-31 23:59:59.999999'
)

-- ===============================
-- STEP 3: Combine Everything into a Timeline
-- Take One Leading Source for Each Attribute
-- ===============================

SELECT
    boomi.tkey_budget_transaction,
    tr.bkey_budget_transaction,
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

LEFT JOIN source_anaplan_budget boomi
    ON boomi.bkey_budget_transaction = tr.bkey_budget_transaction
    AND boomi.valid_from <= tr.valid_from 
    AND COALESCE(boomi.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
    AND boomi.bkey_source = 'BOOMI' -- add only the source specific bkey's;