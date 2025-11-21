WITH customer AS (
    SELECT
        mds.bkey_customer_source,
        mds.bkey_customer AS customer_code,
        mds.bkey_customer_global,
        mds.customer_company,
        mds.customer_id,
        mds.customer_name,
        mds.customer_address,
        mds.customer_legal_number,
        mds.customer_city,
        mds.customer_zip_code,
        CAST(mds.customer_group AS VARCHAR) AS customer_group,
        CAST(mds.customer_group_description AS VARCHAR) AS customer_group_description,
        mds.customer_industry,
        mds.customer_multinational_legal_number,
        mds.customer_multinational_name,
        mds.customer_gkam,
        mds.customer_affiliate,
        mds.customer_country_code,
        mds.valid_from,
        mds.valid_to,
        mds.is_current
    FROM {{ ref('customer_mds') }} mds
    UNION ALL
    SELECT
        dynamics.bkey_customer_source,
        dynamics.bkey_customer AS customer_code,
        dynamics.bkey_customer_global,
        dynamics.customer_company,
        dynamics.customer_id,
        dynamics.customer_name,
        dynamics.customer_address,  
        dynamics.customer_legal_number,
        dynamics.customer_city,
        dynamics.customer_zip_code,
        dynamics.customer_group,
        dynamics.customer_group_description,
        CAST(dynamics.customer_industry AS VARCHAR) AS customer_industry,
        CAST(dynamics.customer_multinational_legal_number AS VARCHAR) AS customer_multinational_legal_number,
        CAST(dynamics.customer_multinational_name AS VARCHAR) AS customer_multinational_name,
        dynamics.customer_gkam,
        dynamics.customer_affiliate,
        dynamics.customer_country_code,
        dynamics.valid_from,
        dynamics.valid_to,
        dynamics.is_current
    FROM {{ ref('customer_dynamics') }} dynamics
)

SELECT 
    *
FROM customer