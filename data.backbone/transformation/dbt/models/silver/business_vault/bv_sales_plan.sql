WITH sales_plan AS (
    SELECT DISTINCT
        hub.bkey_sales_plan,
        hub.bkey_source,
        sat.sales_plan_budget_line_number,
        sat.sales_plan_category,
        sat.sales_plan_plan,
        sat.sales_plan_version,
        sat.sales_plan_company,
        sat.sales_plan_closure_date,
        sales_plan_global_customer_code,
        sales_plan_customer_id,
        sales_plan_customer_name,
        sales_plan_business_type,
        sales_plan_product_global_code,
        sales_plan_poduct_global_name,
        sat.sales_plan_uom,
        sat.sales_plan_quantity,
        sat.sales_plan_quantity_metric_ton,
        sat.sales_plan_group_currency_total_amount,
        sat.sales_plan_home_currency_total_amount,
        sat.sales_plan_budget_currency_total_amount,
        sat.sales_plan_group_currency_cogs1_amount,
        sat.sales_plan_home_currency_cogs1_amount,
        sat.sales_plan_budget_currency_cogs1_amount,
        sat.sales_plan_group_currency_cogs2_amount,
        sat.sales_plan_home_currency_cogs2_amount,
        sat.sales_plan_budget_currency_cogs2_amount,
        sat.sales_plan_home_currency,
        sat.sales_plan_plan_rate,
        sat.sales_plan_industry_type_code,
        sat.sales_plan_customer_code_cgk,
        sat.sales_plan_destination_country,
        sat.sales_plan_currency,
        sat.valid_from,
        sat.valid_to,
        sat.is_current
    FROM {{ ref('rv_hub_sales_plan') }} hub
    LEFT JOIN {{ ref('rv_sat_sales_plan') }} sat 
        ON hub.bkey_sales_plan_source = sat.bkey_sales_plan_source
)

SELECT 
    *
FROM sales_plan;
