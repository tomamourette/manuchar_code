WITH source_public_holiday AS (
    SELECT
        sph.tkey_publicholiday_lakehouse,
        sph.date,
        sph.country_region_code,
        sph.country_or_region,
        sph.holiday_name,
        sph.normalized_holiday_name,
        sph.is_paid_time_off
    FROM {{ ref('rv_sat_public_holiday')}} AS sph
)

SELECT
    tkey_publicholiday_lakehouse,
    date,
    country_region_code,
    country_or_region,
    holiday_name,
    normalized_holiday_name,
    is_paid_time_off
FROM source_public_holiday