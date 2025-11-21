-- ===============================
-- STEP 1: Extracting Entity Data
-- From Different Sources
-- ===============================

WITH source_industry AS (
    SELECT
        hub.bkey_industry,
        hub.bkey_source,
        sat.industry_name,
        sat.industry_group,
        sat.valid_from,
        sat.valid_to
    FROM {{ ref('rv_hub_industry')}} hub
    LEFT JOIN {{ ref('rv_sat_industry')}} sat ON hub.bkey_industry_source = sat.bkey_industry_source
    WHERE is_current = 1 -- add only the latest version
),

-- ===============================
-- STEP 2: Generating Non-overlapping 
-- Time Ranges for Each Industry
-- ===============================

time_ranges AS (
    SELECT
        bkey_industry,
        CAST(time_event AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(time_event) OVER (PARTITION BY bkey_industry ORDER BY time_event), '2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_industry, valid_from AS time_event FROM source_industry
        UNION 
        SELECT bkey_industry, valid_to AS time_event FROM source_industry
    ) AS time_events
    WHERE time_event <> '2999-12-31 23:59:59.999999'
)

-- ===============================
-- STEP 3: Combining Data into a Unified Timeline
-- Selecting the Leading Source for Each Attribute
-- ===============================

SELECT
    tr.bkey_industry,
    COALESCE(mds.industry_name, mona.industry_name) AS industry_name,
    mds.industry_group,
    tr.valid_from,
    tr.valid_to,
    CASE
        WHEN tr.valid_to = CAST('2999-12-31 23:59:59.999999' AS DATETIME2(6)) THEN 1
        ELSE 0
    END AS is_current
FROM time_ranges tr

LEFT JOIN source_industry mds
    ON mds.bkey_industry = tr.bkey_industry 
    AND mds.valid_from <= tr.valid_from 
    AND COALESCE(mds.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
    AND mds.bkey_source = 'MDS' -- add only the source specific bkey's

LEFT JOIN source_industry mona
    ON mona.bkey_industry = tr.bkey_industry 
    AND mona.valid_from <= tr.valid_from 
    AND COALESCE(mona.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
    AND mona.bkey_source = 'MONA' -- add only the source specific bkey's