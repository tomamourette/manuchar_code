WITH public_holiday AS (
    SELECT
        tkey_publicholiday_lakehouse,
        date,
        country_region_code,
        country_or_region,
        holiday_name,
        normalized_holiday_name,
        is_paid_time_off
    FROM {{ ref('public_holiday_oil_genericdata') }}
)

SELECT 
    *
FROM public_holiday