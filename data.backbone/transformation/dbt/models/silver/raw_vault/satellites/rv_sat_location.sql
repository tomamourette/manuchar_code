WITH location AS (
    SELECT 
        mds.bkey_location_source,
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
        mds.valid_from,
        mds.valid_to,
        mds.is_current
    FROM {{ ref('location_mds') }} AS mds
)

SELECT
    *
FROM location