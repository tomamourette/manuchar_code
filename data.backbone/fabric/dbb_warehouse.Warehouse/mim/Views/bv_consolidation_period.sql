-- Auto Generated (Do not modify) B25423889D477D7A5C4C5301EFA8A99CA0584FF274F539A96726D9E92D749C5A
create view "mim"."bv_consolidation_period" as -- ===============================
-- STEP 1: Extracting Entity Data
-- From Different Sources in a Single CTE
-- ===============================

WITH source_consolidation_period AS (
    SELECT
        hub.bkey_consolidation_period,
        hub.bkey_source,
        sat.consolidation_id,
        sat.consolidation_name,
        sat.consolidation_year,
        sat.consolidation_month,
        sat.consolidation_date,
        sat.consolidation_version,
        sat.consolidation_category,
        consolidation_category_description,
        sat.consolidation_scope,
        sat.consolidation_l4l_scope,
        sat.valid_from,
        sat.valid_to
    FROM "dbb_warehouse"."mim"."rv_hub_consolidation_period" hub
    LEFT JOIN "dbb_warehouse"."mim"."rv_sat_consolidation_period" sat ON hub.bkey_consolidation_period_source = sat.bkey_consolidation_period_source
    WHERE sat.is_current = 1 -- add only the latest version
),

-- ===============================
-- STEP 2: Generating Non-overlapping 
-- Time Ranges for Each bkey
-- ===============================

time_ranges AS (
    SELECT
        bkey_consolidation_period,
        CAST(time_event AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(time_event) OVER (PARTITION BY bkey_consolidation_period ORDER BY time_event), '2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_consolidation_period, valid_from AS time_event FROM source_consolidation_period
        UNION 
        SELECT bkey_consolidation_period, valid_to AS time_event FROM source_consolidation_period
    ) AS time_events
    WHERE time_event <> '2999-12-31 23:59:59.999999'
)

-- ===============================
-- STEP 3: Combine Everything into a Timeline
-- Take One Leading Source for Each Attribute
-- ===============================

SELECT
    tr.bkey_consolidation_period,
    mona.consolidation_id,
    mona.consolidation_name,
    mona.consolidation_year,
    mona.consolidation_month,
    mona.consolidation_date,
    mona.consolidation_version,
    mona.consolidation_category,
    consolidation_category_description,
    mona.consolidation_scope,
    mona.consolidation_l4l_scope,
    tr.valid_from,
    tr.valid_to,
    CASE
        WHEN tr.valid_to = CAST('2999-12-31 23:59:59.999999' AS DATETIME2(6)) THEN 1
        ELSE 0
    END AS is_current
FROM time_ranges tr

LEFT JOIN source_consolidation_period mona
    ON mona.bkey_consolidation_period = tr.bkey_consolidation_period
    AND mona.valid_from <= tr.valid_from 
    AND COALESCE(mona.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
    AND mona.bkey_source = 'MONA' -- add only the source specific bkey's;