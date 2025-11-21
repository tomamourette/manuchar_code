WITH business_unit AS (
    SELECT
        bkey_business_unit_source,
        business_unit_name,
        valid_from,
        valid_to,
        is_current
    FROM {{ ref('business_unit_mds') }}
)

SELECT 
    *
FROM business_unit