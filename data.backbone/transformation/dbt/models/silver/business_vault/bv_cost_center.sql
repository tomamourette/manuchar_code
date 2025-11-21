-- ===============================
-- STEP 1: Extracting Entity Data
-- From Different Sources in a Single CTE
-- ===============================

WITH source_cost_center AS (
    SELECT
        hub.bkey_cost_center,
        hub.bkey_source,
        sat.cost_center_code,
        sat.cost_center_description,
        sat.valid_from,
        sat.valid_to
    FROM {{ ref('rv_hub_cost_center')}} hub
    LEFT JOIN {{ ref('rv_sat_cost_center')}} sat ON hub.bkey_cost_center_source = sat.bkey_cost_center_source
    WHERE sat.is_current = 1 -- add only the latest version
),

-- ===============================
-- STEP 2: Generating Non-overlapping 
-- Time Ranges for Each bkey
-- ===============================

time_ranges AS (
    SELECT
        bkey_cost_center,
        CAST(time_event AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(time_event) OVER (PARTITION BY bkey_cost_center ORDER BY time_event), '2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_cost_center, valid_from AS time_event FROM source_cost_center
        UNION 
        SELECT bkey_cost_center, valid_to AS time_event FROM source_cost_center
    ) AS time_events
    WHERE time_event <> '2999-12-31 23:59:59.999999'
)

-- ===============================
-- STEP 3: Combine Everything into a Timeline
-- Take One Leading Source for Each Attribute
-- ===============================

SELECT
    tr.bkey_cost_center,
    dbb.cost_center_code,
    dbb.cost_center_description,
    tr.valid_from,
    tr.valid_to,
    CASE
        WHEN tr.valid_to = CAST('2999-12-31 23:59:59.999999' AS DATETIME2(6)) THEN 1
        ELSE 0
    END AS is_current
FROM time_ranges tr

LEFT JOIN source_cost_center dbb
    ON dbb.bkey_cost_center = tr.bkey_cost_center
    AND dbb.valid_from <= tr.valid_from 
    AND COALESCE(dbb.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
    AND dbb.bkey_source = 'DBB_LAKEHOUSE' -- add only the source specific bkey's