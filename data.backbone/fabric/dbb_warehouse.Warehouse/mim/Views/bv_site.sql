-- Auto Generated (Do not modify) 1BD2B7FCD3B2BD767B796EDD0474EB867447F55FFC47E0243EE5CA0ED982CB2F
create view "mim"."bv_site" as -- ===============================
-- STEP 1: Extracting Entity Data
-- From Different Sources
-- ===============================

WITH source_site AS (
    SELECT
        hub.bkey_site,
        hub.bkey_source,
        sat.site_code,
        sat.site_name,
        sat.site_status,
        sat.site_main_activity,
        sat.site_property_type,
        sat.site_latitude,
        sat.site_longitude,
        sat.site_is_bonded,
        sat.site_location_code,
        sat.site_location_name,
        sat.site_location_status,
        sat.site_location_type,
        sat.site_location_property_type,
        sat.site_location_size,
        sat.site_location_storage_type,
        sat.site_location_dry_storage_capacity,
        sat.site_location_liquid_storage_capacity,
        sat.valid_from,
        sat.valid_to
    FROM "dbb_warehouse"."mim"."rv_hub_site" hub
    LEFT JOIN "dbb_warehouse"."mim"."rv_sat_site" sat ON hub.bkey_site_source = sat.bkey_site_source
    WHERE is_current = 1 -- add only the latest version
),

-- ===============================
-- STEP 2: Generating Non-overlapping 
-- Time Ranges for Each Industry
-- ===============================

time_ranges AS (
    SELECT
        bkey_site,
        CAST(time_event AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(time_event) OVER (PARTITION BY bkey_site ORDER BY time_event), '2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_site, valid_from AS time_event FROM source_site
        UNION 
        SELECT bkey_site, valid_to AS time_event FROM source_site
    ) AS time_events
    WHERE time_event <> '2999-12-31 23:59:59.999999'
)

-- ===============================
-- STEP 3: Combining Data into a Unified Timeline
-- Selecting the Leading Source for Each Attribute
-- ===============================

SELECT
    tr.bkey_site,
    boomi.site_code,
    boomi.site_name,
    boomi.site_status,
    boomi.site_main_activity,
    boomi.site_property_type,
    boomi.site_latitude,
    boomi.site_longitude,
    boomi.site_is_bonded,
    boomi.site_location_code,
    boomi.site_location_name,
    boomi.site_location_status,
    boomi.site_location_type,
    boomi.site_location_property_type,
    boomi.site_location_size,
    boomi.site_location_storage_type,
    boomi.site_location_dry_storage_capacity,
    boomi.site_location_liquid_storage_capacity,
    tr.valid_from,
    tr.valid_to,
    CASE
        WHEN tr.valid_to = CAST('2999-12-31 23:59:59.999999' AS DATETIME2(6)) THEN 1
        ELSE 0
    END AS is_current
FROM time_ranges tr

LEFT JOIN source_site boomi
    ON boomi.bkey_site = tr.bkey_site 
    AND boomi.valid_from <= tr.valid_from 
    AND COALESCE(boomi.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
    AND boomi.bkey_source = 'BOOMI' -- add only the source specific bkey's;