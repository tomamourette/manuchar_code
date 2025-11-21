-- ===============================
-- STEP 1: Extracting Entity Data
-- From Different Sources in a Single CTE
-- ===============================

WITH source_account_header AS (
    SELECT
        hub.bkey_account_header,
        hub.bkey_source,
        sat.account_header_number,
        sat.account_header_type,
        sat.account_header_hierarchy_level_2,
        sat.account_header_hierarchy_level_3,
        sat.account_header_reporting_view,
        sat.account_header_hierarchy_level_1,
        sat.account_header_detail,
        sat.account_header_sort_order,
        sat.account_header_calculation_type,
        sat.valid_from,
        sat.valid_to
    FROM {{ ref('rv_hub_account_header')}} hub
    LEFT JOIN {{ ref('rv_sat_account_header')}} sat ON hub.bkey_account_header_source = sat.bkey_account_header_source
    WHERE sat.is_current = 1 -- add only the latest version
),

-- ===============================
-- STEP 2: Generating Non-overlapping 
-- Time Ranges for Each bkey
-- ===============================

time_ranges AS (
    SELECT
        bkey_account_header,
        CAST(time_event AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(time_event) OVER (PARTITION BY bkey_account_header ORDER BY time_event), '2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_account_header, valid_from AS time_event FROM source_account_header
        UNION 
        SELECT bkey_account_header, valid_to AS time_event FROM source_account_header
    ) AS time_events
    WHERE time_event <> '2999-12-31 23:59:59.999999'
)


-- ===============================
-- STEP 3: Combine Everything into a Timeline
-- Take One Leading Source for Each Attribute
-- ===============================

SELECT
    tr.bkey_account_header,
    mds.account_header_number,
    mds.account_header_type,
    mds.account_header_hierarchy_level_2,
    mds.account_header_hierarchy_level_3,
    mds.account_header_reporting_view,
    mds.account_header_hierarchy_level_1,
    mds.account_header_detail,
    mds.account_header_sort_order,
    mds.account_header_calculation_type,
    tr.valid_from,
    tr.valid_to,
    CASE
        WHEN tr.valid_to = CAST('2999-12-31 23:59:59.999999' AS DATETIME2(6)) THEN 1
        ELSE 0
    END AS is_current
FROM time_ranges tr

LEFT JOIN source_account_header mds
    ON mds.bkey_account_header = tr.bkey_account_header 
    AND mds.valid_from <= tr.valid_from 
    AND COALESCE(mds.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
    AND mds.bkey_source = 'MDS' -- add only the source specific bkey's