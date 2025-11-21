WITH source_location AS (
	SELECT
		-- Keys
		CAST(ROW_NUMBER() OVER(ORDER BY loc.bkey_location) AS BIGINT) AS tkey_location,
		CAST(loc.bkey_location AS VARCHAR(255)) AS bkey_location,	
		-- Attributes
		CAST(loc.bkey_location AS VARCHAR(255)) AS location_code,
        CAST(loc.location_name AS VARCHAR(255)) AS location_name,
        CAST(loc.location_address AS VARCHAR(255)) AS location_address,
        CAST(loc.location_city AS VARCHAR(255)) AS location_city,
        CAST(loc.location_zip_code AS VARCHAR(255)) AS location_zip_code,
        CAST(loc.location_longitude AS DECIMAL) AS location_longitude,
        CAST(loc.location_latitude AS DECIMAL) AS location_latitude,
        CAST(loc.location_country_code AS VARCHAR(2)) AS location_country_code,
        CAST(loc.location_type AS VARCHAR(50)) AS location_type,
        CAST(loc.location_type_sort AS VARCHAR(50)) AS location_type_sort,
        CAST(loc.location_company AS VARCHAR(255)) AS location_company,
		-- History metadata
		CAST(loc.valid_from AS DATETIME2(6)) AS valid_from,
		CAST(loc.valid_to AS DATETIME2(6)) AS valid_to,
		CAST(loc.is_current AS BIT) AS is_current
	FROM {{ ref('bv_location') }} AS loc
	WHERE loc.is_current = 1 -- add only the latest version
)

SELECT 
    tkey_location,
    bkey_location,
    location_code,
    location_name,
    location_address,
    location_city,
    location_zip_code,
    location_longitude,
    location_latitude,
    location_country_code,
    location_type,
    location_type_sort,
    location_company,
	valid_from,
	valid_to,
	is_current
FROM source_location