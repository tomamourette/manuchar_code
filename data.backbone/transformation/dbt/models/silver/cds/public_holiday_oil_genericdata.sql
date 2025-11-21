WITH source_oil_genericdata_publicholidays AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY dbb.countryRegionCode, dbb.countryOrRegion, dbb.holidayName, dbb.normalizeHolidayName, dbb.isPaidTimeOff, dbb.date) AS tkey_publicholiday_lakehouse,
        CONVERT(DATE, dbb.date) AS date,
        dbb.countryRegionCode AS country_region_code,
        dbb.countryOrRegion AS country_or_region,
        dbb.holidayName AS holiday_name,
        dbb.normalizeHolidayName AS normalized_holiday_name,
        dbb.isPaidTimeOff AS is_paid_time_off
    FROM {{ ref('sv_oil_genericdata_publicholidays')}} AS dbb
)

SELECT 
    *
FROM source_oil_genericdata_publicholidays