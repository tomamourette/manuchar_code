-- ===============================
-- STEP 1: Extracting Entity Data
-- From Different Sources in a Single CTE
-- ===============================

WITH source_business_unit AS (
    SELECT
        hub.bkey_business_unit,
        hub.bkey_source,
        sat.business_unit_name,
        sat.valid_from,
        sat.valid_to
    FROM {{ ref('rv_hub_business_unit')}} hub
    LEFT JOIN {{ ref('rv_sat_business_unit')}} sat ON hub.bkey_business_unit_source = sat.bkey_business_unit_source
    WHERE sat.is_current = 1 -- add only the latest version
),

-- ===============================
-- STEP 2: Generating Non-overlapping 
-- Time Ranges for Each bkey
-- ===============================

time_ranges AS (
    SELECT
        bkey_business_unit,
        CAST(time_event AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(time_event) OVER (PARTITION BY bkey_business_unit ORDER BY time_event), '2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_business_unit, valid_from AS time_event FROM source_business_unit
        UNION 
        SELECT bkey_business_unit, valid_to AS time_event FROM source_business_unit
    ) AS time_events
    WHERE time_event <> '2999-12-31 23:59:59.999999'
)

-- ===============================
-- STEP 3: Combine Everything into a Timeline
-- Take One Leading Source for Each Attribute
-- ===============================

SELECT
    tr.bkey_business_unit,
    mds.business_unit_name,
    tr.valid_from,
    tr.valid_to,
    CASE
        WHEN tr.valid_to = CAST('2999-12-31 23:59:59.999999' AS DATETIME2(6)) THEN 1
        ELSE 0
    END AS is_current
FROM time_ranges tr

LEFT JOIN source_business_unit mds
    ON mds.bkey_business_unit = tr.bkey_business_unit
    AND mds.valid_from <= tr.valid_from 
    AND COALESCE(mds.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
    AND mds.bkey_source = 'MDS' -- add only the source specific bkey's