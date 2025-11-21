-- ===============================
-- STEP 1: Extracting Entity Data
-- From Different Sources
-- ===============================

WITH source_location AS (
    SELECT
        hub.bkey_location,
        hub.bkey_source,
        sat.location_name,
        sat.location_address,
        sat.location_city,
        sat.location_zip_code,
        sat.location_longitude,
        sat.location_latitude,
        sat.location_country_code,
        sat.location_type,
        sat.location_type_sort,
        sat.location_company,
        sat.valid_from,
        sat.valid_to
    FROM {{ ref('rv_hub_location')}} hub
    LEFT JOIN {{ ref('rv_sat_location')}} sat ON hub.bkey_location_source = sat.bkey_location_source
    WHERE sat.is_current = 1 -- add only the latest version
),

-- ===============================
-- STEP 2: Generating Non-overlapping 
-- Time Ranges for Each bkey
-- ===============================

time_ranges AS (
    SELECT
        bkey_location,
        CAST(time_event AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(time_event) OVER (PARTITION BY bkey_location ORDER BY time_event), '2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_location, valid_from AS time_event FROM source_location
        UNION 
        SELECT bkey_location, valid_to AS time_event FROM source_location
    ) AS time_events
    WHERE time_event <> '2999-12-31 23:59:59.999999'
)

-- ===============================
-- STEP 3: Combine Everything into a Timeline
-- Take One Leading Source for Each Attribute
-- ===============================

SELECT
    tr.bkey_location,
    mds.location_name,
    mds.location_address,
    mds.location_city,
    mds.location_zip_code,
    mds.location_longitude,
    mds.location_latitude,
    mds.location_country_code,
    mds.location_type,
    mds.location_type_sort,
    mds.location_company,
    tr.valid_from,
    tr.valid_to,
    CASE
        WHEN tr.valid_to = CAST('2999-12-31 23:59:59.999999' AS DATETIME2(6)) THEN 1
        ELSE 0
    END AS is_current
FROM time_ranges tr

LEFT JOIN source_location mds
    ON mds.bkey_location = tr.bkey_location
    AND mds.valid_from <= tr.valid_from 
    AND COALESCE(mds.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
    AND mds.bkey_source = 'MDS' -- add only the source specific bkey's