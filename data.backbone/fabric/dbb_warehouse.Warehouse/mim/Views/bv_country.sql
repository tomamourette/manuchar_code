-- Auto Generated (Do not modify) 25D513EB47E3E2B9C16295E13097E56C82E816FD2466DAB71748B934C753FFBF
create view "mim"."bv_country" as -- ===============================
-- STEP 1: Extracting Entity Data
-- From Different Sources
-- ===============================

WITH source_country AS (
    SELECT
        hub.bkey_country,
        hub.bkey_source,
        sat.country_name,
        sat.country_iso_code,
        sat.country_sort,
        sat.country_region_level_1,
        sat.country_region_level_1_sort,
        sat.country_region_level_2,
        sat.country_region_level_2_sort,
        sat.country_continent,
        sat.valid_from,
        sat.valid_to
    FROM "dbb_warehouse"."mim"."rv_hub_country" AS hub 
    INNER JOIN "dbb_warehouse"."mim"."rv_sat_country" AS sat ON hub.bkey_country_source = sat.bkey_country_source
    WHERE is_current = 1 -- add only the latest version
),

-- ===============================
-- STEP 2: Generating Non-overlapping 
-- Time Ranges for Each bkey
-- ===============================

time_ranges AS (
    SELECT
        bkey_country,
        CAST(time_event AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(time_event) OVER (PARTITION BY bkey_country ORDER BY time_event),'2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_country, valid_from AS time_event FROM source_country
        UNION
        SELECT bkey_country, valid_to AS time_event FROM source_country
    ) AS time_events
    WHERE time_event <> '2999-12-31 23:59:59.999999'
)

-- ===============================
-- STEP 3: Combine Everything into a Timeline
-- Take One Leading Source for Each Attribute
-- ===============================

SELECT
    tr.bkey_country,
    COALESCE(mds.country_name, mona.country_name) AS country_name,
    mds.country_iso_code,
    mds.country_sort,
    COALESCE(mds.country_region_level_1, mona.country_region_level_1) AS country_region_level_1,  
    COALESCE(mds.country_region_level_1_sort, mona.country_region_level_1_sort) AS country_region_level_1_sort, 
    COALESCE(mds.country_region_level_2, mona.country_region_level_2) AS country_region_level_2,  
    mds.country_region_level_2_sort,
    mona.country_continent,
    tr.valid_from,
    tr.valid_to,
    CASE
        WHEN tr.valid_to = CAST('2999-12-31 23:59:59.999999' AS DATETIME2(6)) THEN 1 ELSE 0
    END AS is_current
FROM time_ranges tr

LEFT JOIN source_country mona
ON mona.bkey_country = tr.bkey_country 
AND mona.valid_from <= tr.valid_from 
AND COALESCE(mona.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
AND mona.bkey_source = 'MONA' -- add only the source specific bkey's

LEFT JOIN source_country mds
ON mds.bkey_country = tr.bkey_country 
AND mds.valid_from <= tr.valid_from 
AND COALESCE(mds.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
AND mds.bkey_source = 'MDS' -- add only the source specific bkey's;