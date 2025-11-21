-- Auto Generated (Do not modify) 9F834F5C5B7C98B7C1E34D20BA2451A3B87A762273B06B260FB4C638AF5A7559
create view "mim"."bv_company" as -- ===============================
-- STEP 1: Extracting Entity Data
-- From Different Sources in a Single CTE
-- ===============================

WITH source_company AS (
    SELECT
        hub.bkey_company,
        hub.bkey_source,
        sat.company_name,
        sat.company_active_code,
        sat.company_consolidation_method,
        sat.company_group_percentage,
        sat.company_minor_percentage,
        sat.company_group_control_percentage,
        sat.company_local_currency,
        sat.company_home_currency,
        sat.company_country_code,
        sat.company_tree_level_1,
        sat.company_tree_level_2,
        sat.company_min_reporting_period,
        sat.valid_from,
        sat.valid_to
    FROM "dbb_warehouse"."mim"."rv_hub_company" AS hub 
    INNER JOIN "dbb_warehouse"."mim"."rv_sat_company" AS sat ON hub.bkey_company_source = sat.bkey_company_source
    -- WHERE sat.is_current = 1 -- add only the latest version
),

-- ===============================
-- STEP 2: Generating Non-overlapping 
-- Time Ranges for Each bkey_company
-- ===============================

time_ranges AS (
    SELECT
        bkey_company,
        CAST(time_event AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(time_event) OVER (PARTITION BY bkey_company ORDER BY time_event), '2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_company, valid_from AS time_event FROM source_company
        UNION
        SELECT bkey_company, valid_to AS time_event FROM source_company
    ) AS time_events
    WHERE time_event <> '2999-12-31 23:59:59.999999'
)

-- ===============================
-- STEP 3: Combine Everything into a Timeline
-- Take One Leading Source for Each Attribute
-- ===============================

SELECT
    tr.bkey_company,
    COALESCE(mona.company_name, mds.company_name, dyn.company_name) AS company_name,
    mds.company_active_code,
    mona.company_consolidation_method,
    mona.company_group_percentage,
    mona.company_minor_percentage,
    mona.company_group_control_percentage,
    mona.company_local_currency,
    mona.company_home_currency,
    mona.company_country_code,
    COALESCE(mona.company_tree_level_1, mds.company_tree_level_1) AS company_tree_level_1,
    COALESCE(mona.company_tree_level_2, mds.company_tree_level_2) AS company_tree_level_2,
    mona.company_min_reporting_period,
    tr.valid_from,
    tr.valid_to,
    CASE
        WHEN tr.valid_to = CAST('2999-12-31 23:59:59.999999' AS DATETIME2(6))
            THEN 1
        ELSE 0
    END AS is_current
FROM time_ranges tr

LEFT JOIN source_company mona
ON mona.bkey_company = tr.bkey_company 
AND mona.valid_from <= tr.valid_from 
AND COALESCE(mona.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
AND mona.bkey_source = 'MONA' -- add only the source specific bkey's

LEFT JOIN source_company mds
ON mds.bkey_company = tr.bkey_company 
AND mds.valid_from <= tr.valid_from 
AND COALESCE(mds.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
AND mds.bkey_source = 'MDS' -- add only the source specific bkey's

LEFT JOIN source_company dyn
ON dyn.bkey_company = tr.bkey_company 
AND dyn.valid_from <= tr.valid_from 
AND COALESCE(dyn.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
AND dyn.bkey_source = 'DYNAMICS' -- add only the source specific bkey's;