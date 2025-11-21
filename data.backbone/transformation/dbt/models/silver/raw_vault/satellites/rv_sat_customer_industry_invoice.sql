WITH customer_industry_invoice AS (
    SELECT
        mds.bkey_customer_industry_invoice_source,
        mds.customer_industry_invoice_name,
        mds.customer_industry_invoice_group,
        mds.valid_from,
        mds.valid_to,
        mds.is_current
    FROM {{ ref('customer_industry_invoice_mds') }} mds
    UNION ALL
    SELECT
        dyn.bkey_customer_industry_invoice_source,
        CAST(customer_industry_invoice_name AS VARCHAR) AS customer_industry_invoice_name,
        CAST(dyn.customer_industry_invoice_group AS VARCHAR) AS customer_industry_invoice_group,
        dyn.valid_from,
        dyn.valid_to,
        dyn.is_current
    FROM {{ ref('customer_industry_invoice_dynamics') }} dyn
)

SELECT
    *
FROM customer_industry_invoice