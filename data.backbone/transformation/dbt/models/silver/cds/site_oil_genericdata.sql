-- ===============================
-- STEP 1: Extracting Historical Data (SCD2)
-- Tracking changes in Locations over time and inheriting the Site business key
-- ===============================
WITH location_history AS (
    SELECT 
        l.LocationCode + '_BOOMI' AS bkey_site_source,  -- Inherit Site's Business Key
        l.LocationCode AS bkey_site,
        'BOOMI' AS bkey_source,
        l.LocationCode,
        l.LocationName,
        l.Status AS LocationStatus,
        l.LocationType,
        l.LocationPropertyType,
        l.LocationSize,
        l.StorageType,
        l.DryStorageCapacity,
        l.LiquidStorageCapacity,
        CAST(l.ModifiedDateTime AS DATETIME2(6)) AS valid_from,
        CAST(LEAD(l.ModifiedDateTime) OVER (PARTITION BY l.LocationCode ORDER BY l.ModifiedDateTime) AS DATETIME2(6)) AS valid_to
    FROM  {{ ref("sv_oil_genericdata_sites") }} s 
    LEFT JOIN {{ ref("sv_oil_genericdata_locations") }} l ON LEFT(l.LocationCode, LEN(s.SiteCode)) = s.SiteCode  -- Link Locations to Sites
),

-- ===============================
-- STEP 2: Generate Time Ranges for SCD2
-- Consolidate timestamps from Location history into a unified timeline using LEAD logic
-- ===============================
timeranges AS (
    SELECT  
        bkey_site_source,
        bkey_site,
        bkey_source,
        CAST(valid_from AS DATETIME2(6)) AS valid_from,
        CAST(LEAD(valid_from, 1, '2999-12-31 23:59:59.999999') OVER (PARTITION BY bkey_site ORDER BY valid_from) AS DATETIME2(6)) AS valid_to
    FROM location_history t
    WHERE valid_from IS NOT NULL
),

-- ===============================
-- STEP 3: Extracting Current Data (SCD1)
-- Retrieve the latest current Site details using ROW_NUMBER()
-- ===============================
site_current AS (
    SELECT 
        *
    FROM (
        SELECT 
            l.LocationCode + '_BOOMI' AS bkey_site_source,
            l.LocationCode AS bkey_site,
            'BOOMI' AS bkey_source,
            s.SiteCode,
            s.SiteName,
            s.Status AS SiteStatus,
            s.MainActivity,
            s.SitePropertyType,
            s.Latitude,
            s.Longitude,
            s.IsBonded,
            ROW_NUMBER() OVER (PARTITION BY l.LocationCode ORDER BY s.ModifiedDateTime DESC) AS rn
        FROM {{ ref("sv_oil_genericdata_sites") }} s
        LEFT JOIN {{ ref("sv_oil_genericdata_locations") }} l ON LEFT(l.LocationCode, LEN(s.SiteCode)) = s.SiteCode  -- Link Locations to Sites
        WHERE l.LocationCode IS NOT NULL
    ) t
    WHERE rn = 1
)

-- ===============================
-- STEP 4: Combine Data into a Full Site-Location Timeline
-- Join the current Site data (SCD1) with historical Location data (SCD2) using the unified time ranges
-- ===============================
SELECT 
    COALESCE(tr.bkey_site_source, '') AS bkey_site_source,
    COALESCE(tr.bkey_site, '') AS bkey_site,
    'BOOMI' AS bkey_source,
    COALESCE(e1.SiteCode, '') AS site_code,
    e1.SiteName AS site_name,
    e1.SiteStatus AS site_status,
    e1.MainActivity AS site_main_activity,
    e1.SitePropertyType AS site_property_type,
    e1.Latitude AS site_latitude,
    e1.Longitude AS site_longitude,
    e1.IsBonded AS site_is_bonded,
    COALESCE(e2.LocationCode, '') AS site_location_code,
    e2.LocationName AS site_location_name,
    e2.LocationStatus AS site_location_status,
    e2.LocationType AS site_location_type,
    e2.LocationPropertyType AS site_location_property_type,
    e2.LocationSize AS site_location_size,
    e2.StorageType AS site_location_storage_type,
    e2.DryStorageCapacity AS site_location_dry_storage_capacity,
    e2.LiquidStorageCapacity AS site_location_liquid_storage_capacity,
    tr.valid_from,
    COALESCE(tr.valid_to, '2999-12-31 23:59:59.999999') AS valid_to,
    CASE 
        WHEN tr.valid_to = '2999-12-31 23:59:59.999999' THEN 1 
        ELSE 0
    END AS is_current
FROM timeranges tr
LEFT JOIN site_current e1 
ON e1.bkey_site_source = tr.bkey_site_source
LEFT JOIN location_history e2
ON e2.bkey_site_source = tr.bkey_site_source
AND e2.valid_from <= tr.valid_from 
AND COALESCE(e2.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from;
