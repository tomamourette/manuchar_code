-- ===============================
-- STEP 1: Extracting Entity Data
-- From Different Sources
-- ===============================

WITH source_vessel AS (
    SELECT
        hub.bkey_vessel,
        hub.bkey_source,
        sat.vessel_id,
        sat.vessel_description,
        sat.valid_from,
        sat.valid_to
    FROM {{ ref('rv_hub_vessel')}} hub
    LEFT JOIN {{ ref('rv_sat_vessel')}} sat ON hub.bkey_vessel_source = sat.bkey_vessel_source
    WHERE sat.is_current = 1 -- add only the latest version
),

-- ===============================
-- STEP 2: Generating Non-overlapping 
-- Time Ranges for Each bkey
-- ===============================

time_ranges AS (
    SELECT
        bkey_vessel,
        CAST(time_event AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(time_event) OVER (PARTITION BY bkey_vessel ORDER BY time_event), '2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_vessel, valid_from AS time_event FROM source_vessel
        UNION 
        SELECT bkey_vessel, valid_to AS time_event FROM source_vessel
    ) AS time_events
    WHERE time_event <> '2999-12-31 23:59:59.999999'
)

-- ===============================
-- STEP 3: Combine Everything into a Timeline
-- Take One Leading Source for Each Attribute
-- ===============================

SELECT
    tr.bkey_vessel,
    dyn.vessel_id,
    dyn.vessel_description,
    tr.valid_from,
    tr.valid_to,
    CASE
        WHEN tr.valid_to = CAST('2999-12-31 23:59:59.999999' AS DATETIME2(6)) THEN 1
        ELSE 0
    END AS is_current
FROM time_ranges tr

LEFT JOIN source_vessel dyn
    ON dyn.bkey_vessel = tr.bkey_vessel
    AND dyn.valid_from <= tr.valid_from 
    AND COALESCE(dyn.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
    AND dyn.bkey_source = 'DYNAMICS' -- add only the source specific bkey's