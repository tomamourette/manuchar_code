-- ===============================
-- STEP 1: Extracting Historical Data (SCD2)
-- Generating valid_from and valid_to using modifieddatetime
-- ===============================

WITH mds_locations_history AS (
    SELECT
        lam.Code + '_MDS' AS bkey_location_source,
        lam.Code AS bkey_location,
        'MDS' AS bkey_source,
        loc.LastChgDateTime AS valid_from,
        LEAD(CAST(loc.LastChgDateTime AS DATETIME2(6))) OVER (PARTITION BY lam.Code ORDER BY loc.LastChgDateTime) AS valid_to
    FROM {{ ref('sv_mds_locationaffiliatesmapping') }} lam
    LEFT JOIN {{ ref('sv_mds_locations') }} loc ON loc.Code = lam.Group_Location_Code_Code
),

-- ===============================
-- STEP 2: Generate Time Ranges for SCD2
-- Consolidating timestamps across history sources to create a unified timeline
-- Filter valid_to IS NOT NULL, because there are dates with NULL value in source
-- ===============================

timeranges AS (
    SELECT 
        bkey_location_source,
        bkey_location,
        bkey_source,
        CAST(valid_from AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(valid_from) OVER (PARTITION BY bkey_location ORDER BY valid_from), '2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_location_source, bkey_location, bkey_source, valid_from, valid_to FROM mds_locations_history
    ) AS time_events
),

-- ===============================
-- STEP 3: Extracting Current Data (SCD1)
-- Only Latest Record per Supplier is Kept for Address Details
-- ===============================

mds_locations_current AS (
    SELECT 
        bkey_location_source,
        bkey_location,
        bkey_source,
        location_name,
        location_address,
        location_city,
        location_zip_code,
        location_longitude,
        location_latitude,
        location_country_code,
        location_type,
        location_type_sort,
        location_company
    FROM (
        SELECT 
            lam.Code + '_MDS' AS bkey_location_source,
            lam.Code AS bkey_location,
            'MDS' AS bkey_source,
            loc.Name AS location_name,
            loc.Address AS location_address,
            loc.City AS location_city,
            loc.ZIP_Code AS location_zip_code,
            loc.Longitude AS location_longitude,
            loc.latitude AS location_latitude,
            cou.ISO_Alpha_3_Code AS location_country_code,
            loc.Location_Type_Name AS location_type,
            loc.Location_Type_Code AS location_type_sort,
            loc.Company_Code AS location_company,
            ROW_NUMBER() OVER (PARTITION BY lam.Code ORDER BY loc.LastChgDateTime DESC) AS rn
        FROM {{ ref('sv_mds_locationaffiliatesmapping') }} lam
        LEFT JOIN {{ ref('sv_mds_locations') }} loc ON loc.Code = lam.Group_Location_Code_Code
        LEFT JOIN {{ ref('sv_mds_countries')}} cou ON loc.Country_Code = cou.Code
    ) AS sub
    WHERE rn = 1
)

-- ===============================
-- STEP 4: Combine Everything into a Full Supplier Timeline
-- - SCD2 (history tables) are joined on ID + valid time range.
-- - SCD1 (current tables) are joined on ID only.
-- ===============================

SELECT
    tr.bkey_location_source,
    tr.bkey_location,
    tr.bkey_source,
    c.location_name,
    c.location_address,
    c.location_city,
    c.location_zip_code,
    c.location_longitude,
    c.location_latitude,
    c.location_country_code,
    c.location_type,
    c.location_type_sort,
    c.location_company,
    tr.valid_from,
    tr.valid_to,
    CASE 
        WHEN tr.valid_to = '2999-12-31 23:59:59.999999' THEN 1 
        ELSE 0
    END AS is_current
FROM timeranges tr

-- ===============================
-- JOIN SCD2 (History) TABLES ON ID + TIME RANGE
-- Ensures correct historical version is retrieved based on the event timestamp.
-- ===============================
LEFT JOIN mds_locations_history e
ON e.bkey_location_source = tr.bkey_location_source
AND e.valid_from <= tr.valid_from 
AND COALESCE(e.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from

LEFT JOIN mds_locations_current c
ON c.bkey_location_source = tr.bkey_location_source