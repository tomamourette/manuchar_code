-- ===============================
-- STEP 1: Extracting Entity Data
-- From Different Sources in a Single CTE
-- ===============================

WITH source_age_group AS (
    SELECT
        hub.bkey_age_group,
        hub.bkey_source,
        sat.age_group_name,
        sat.age_group_id,
        sat.age_group_min_days,
        sat.age_group_max_days,
        sat.age_group_sort,
        sat.valid_from,
        sat.valid_to
    FROM {{ ref('rv_hub_age_group')}} hub
    LEFT JOIN {{ ref('rv_sat_age_group')}} sat ON hub.bkey_age_group_source = sat.bkey_age_group_source
    WHERE sat.is_current = 1 -- add only the latest version
),

-- ===============================
-- STEP 2: Generating Non-overlapping 
-- Time Ranges for Each bkey
-- ===============================

time_ranges AS (
    SELECT
        bkey_age_group,
        CAST(time_event AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(time_event) OVER (PARTITION BY bkey_age_group ORDER BY time_event), '2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_age_group, valid_from AS time_event FROM source_age_group
        UNION 
        SELECT bkey_age_group, valid_to AS time_event FROM source_age_group
    ) AS time_events
    WHERE time_event <> '2999-12-31 23:59:59.999999'
)

-- ===============================
-- STEP 3: Combine Everything into a Timeline
-- Take One Leading Source for Each Attribute
-- ===============================

SELECT
    tr.bkey_age_group,
    mds.age_group_name,
    mds.age_group_id,
    mds.age_group_min_days,
    mds.age_group_max_days,
    mds.age_group_sort,
    tr.valid_from,
    tr.valid_to,
    CASE
        WHEN tr.valid_to = CAST('2999-12-31 23:59:59.999999' AS DATETIME2(6)) THEN 1
        ELSE 0
    END AS is_current
FROM time_ranges tr

LEFT JOIN source_age_group mds
    ON mds.bkey_age_group = tr.bkey_age_group
    AND mds.valid_from <= tr.valid_from 
    AND COALESCE(mds.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
    AND mds.bkey_source = 'MDS' -- add only the source specific bkey's