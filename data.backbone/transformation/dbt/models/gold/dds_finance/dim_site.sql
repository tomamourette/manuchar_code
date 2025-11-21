WITH source_site AS (
	SELECT 
		-- Keys
		CAST(ROW_NUMBER() OVER(ORDER BY si.bkey_site) AS BIGINT) AS tkey_site,
		CAST(si.bkey_site AS VARCHAR(255)) AS bkey_site,
		-- Site Attributes
        CAST(si.site_code AS VARCHAR(255)) AS site_code,
        CAST(si.site_name AS VARCHAR(255)) AS site_name,
        CAST(si.site_status AS VARCHAR(255)) AS site_status,
        CAST(si.site_main_activity AS VARCHAR(255)) AS site_main_activity,
        CAST(si.site_property_type AS VARCHAR(255)) AS site_property_type,
        CAST(si.site_latitude AS VARCHAR(255)) AS site_latitude,
        CAST(si.site_longitude AS VARCHAR(255)) AS site_longitude,
        CAST(si.site_is_bonded AS VARCHAR(255)) AS site_is_bonded,
        -- Location Attributes
        CAST(si.site_location_code AS VARCHAR(255)) AS site_location_code,
        CAST(si.site_location_name AS VARCHAR(255)) AS site_location_name,
        CAST(si.site_location_status AS VARCHAR(255)) AS site_location_status,
        CAST(si.site_location_type AS VARCHAR(255)) AS site_location_type,
        CAST(si.site_location_property_type AS VARCHAR(255)) AS site_location_property_type,
        CAST(si.site_location_size AS VARCHAR(255)) AS site_location_size,
        CAST(si.site_location_storage_type AS VARCHAR(255)) AS site_location_storage_type,
        CAST(si.site_location_dry_storage_capacity AS DECIMAL) AS site_location_dry_storage_capacity,
        CAST(si.site_location_liquid_storage_capacity AS DECIMAL) AS site_location_liquid_storage_capacity,
		-- History metadata
		CAST(si.valid_from AS DATETIME2(6)) AS valid_from,
	  	CAST(si.valid_to AS DATETIME2(6)) AS valid_to,
		CAST(si.is_current AS BIT) AS is_current
	FROM {{ ref('bv_site') }} AS si
	-- WHERE si.is_current = 1 -- add only the latest version
)

SELECT 
	tkey_site,
	bkey_site,
    site_code,
    site_name,
    site_status,
    site_main_activity,
    site_property_type,
    site_latitude,
    site_longitude,
    site_is_bonded,
    site_location_code,
    site_location_name,
    site_location_status,
    site_location_type,
    site_location_property_type,
    site_location_size,
    site_location_storage_type,
    site_location_dry_storage_capacity,
    site_location_liquid_storage_capacity,
	valid_from,
	valid_to,
	is_current
FROM source_site