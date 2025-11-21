-- ===============================
-- STEP 1: Extracting Entity Data
-- From Different Sources in a Single CTE
-- ===============================

WITH source_unit_of_measure AS (
    SELECT
        hub.bkey_unit_of_measure,
        hub.bkey_source,
        sat.unit_of_measure_name,
        sat.unit_of_measure_description,
        sat.unit_of_measure_conversion_to_mt,
        sat.valid_from,
        sat.valid_to
    FROM {{ ref('rv_hub_unit_of_measure')}} AS hub 
    INNER JOIN {{ ref('rv_sat_unit_of_measure')}} AS sat ON hub.bkey_unit_of_measure_source = sat.bkey_unit_of_measure_source
    WHERE sat.is_current = 1 -- add only the latest version
),

-- ===============================
-- STEP 2: Generating Non-overlapping 
-- Time Ranges for Each bkey_unit_of_measure
-- ===============================

time_ranges AS (
    SELECT
        bkey_unit_of_measure,
        CAST(time_event AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(time_event) OVER (PARTITION BY bkey_unit_of_measure ORDER BY time_event), '2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_unit_of_measure, valid_from AS time_event FROM source_unit_of_measure
        UNION
        SELECT bkey_unit_of_measure, valid_to AS time_event FROM source_unit_of_measure
    ) AS time_events
    WHERE time_event <> '2999-12-31 23:59:59.999999'
)

-- ===============================
-- STEP 3: Combine Everything into a Timeline
-- Take One Leading Source for Each Attribute
-- ===============================

SELECT
    tr.bkey_unit_of_measure,
    COALESCE(mds.unit_of_measure_name, dyn.unit_of_measure_name) AS unit_of_measure_name,
    COALESCE(mds.unit_of_measure_description, dyn.unit_of_measure_description) AS unit_of_measure_description,
    COALESCE(mds.unit_of_measure_conversion_to_mt, dyn.unit_of_measure_conversion_to_mt) AS unit_of_measure_conversion_to_mt,
    tr.valid_from,
    tr.valid_to,
    CASE
        WHEN tr.valid_to = CAST('2999-12-31 23:59:59.999999' AS DATETIME2(6))
            THEN 1
        ELSE 0
    END AS is_current
FROM time_ranges tr

LEFT JOIN source_unit_of_measure mds
ON mds.bkey_unit_of_measure = tr.bkey_unit_of_measure 
AND mds.valid_from <= tr.valid_from 
AND COALESCE(mds.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
AND mds.bkey_source = 'MDS' -- add only the source specific bkey's

LEFT JOIN source_unit_of_measure dyn
ON dyn.bkey_unit_of_measure = tr.bkey_unit_of_measure 
AND dyn.valid_from <= tr.valid_from 
AND COALESCE(dyn.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
AND dyn.bkey_source = 'DYNAMICS' -- add only the source specific bkey's