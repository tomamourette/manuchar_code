WITH site AS (
    SELECT
        bkey_site_source,
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
    FROM {{ ref('site_oil_genericdata') }}
)

SELECT 
    *
FROM site