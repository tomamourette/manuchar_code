-- Auto Generated (Do not modify) B1169F6638902471CCE3C43BE49530BEA7A30D583B1D111E1CCBD1568C7A48D2
create view "mim"."bv_stock_age_group" as -- ===============================
-- STEP 1: Extracting Entity Data
-- From Different Sources in a Single CTE
-- ===============================

WITH source_stock_age_group AS (
    SELECT
        hub.bkey_stock_age_group,
        hub.bkey_source,
        sat.stock_age_group_name,
        sat.stock_age_group_id,
        sat.stock_age_group_min_days,
        sat.stock_age_group_max_days,
        sat.stock_age_group_sort,
        sat.valid_from,
        sat.valid_to
    FROM "dbb_warehouse"."mim"."rv_hub_stock_age_group" hub
    LEFT JOIN "dbb_warehouse"."mim"."rv_sat_stock_age_group" sat ON hub.bkey_stock_age_group_source = sat.bkey_stock_age_group_source
    WHERE sat.is_current = 1 -- add only the latest version
),

-- ===============================
-- STEP 2: Generating Non-overlapping 
-- Time Ranges for Each bkey
-- ===============================

time_ranges AS (
    SELECT
        bkey_stock_age_group,
        CAST(time_event AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(time_event) OVER (PARTITION BY bkey_stock_age_group ORDER BY time_event), '2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_stock_age_group, valid_from AS time_event FROM source_stock_age_group
        UNION 
        SELECT bkey_stock_age_group, valid_to AS time_event FROM source_stock_age_group
    ) AS time_events
    WHERE time_event <> '2999-12-31 23:59:59.999999'
)

-- ===============================
-- STEP 3: Combine Everything into a Timeline
-- Take One Leading Source for Each Attribute
-- ===============================

SELECT
    tr.bkey_stock_age_group,
    mds.stock_age_group_name,
    mds.stock_age_group_id,
    mds.stock_age_group_min_days,
    mds.stock_age_group_max_days,
    mds.stock_age_group_sort,
    tr.valid_from,
    tr.valid_to,
    CASE
        WHEN tr.valid_to = CAST('2999-12-31 23:59:59.999999' AS DATETIME2(6)) THEN 1
        ELSE 0
    END AS is_current
FROM time_ranges tr

LEFT JOIN source_stock_age_group mds
    ON mds.bkey_stock_age_group = tr.bkey_stock_age_group
    AND mds.valid_from <= tr.valid_from 
    AND COALESCE(mds.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
    AND mds.bkey_source = 'MDS' -- add only the source specific bkey's;