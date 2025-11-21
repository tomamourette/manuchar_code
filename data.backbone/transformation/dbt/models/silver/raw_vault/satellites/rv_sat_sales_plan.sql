WITH sales_plan AS (
    SELECT 
        bkey_sales_plan_source,
        bkey_sales_plan,
        bkey_source,
        sales_plan_budget_line_number,
        sales_plan_category,
        sales_plan_plan,
        sales_plan_version,
        sales_plan_company,
        sales_plan_closure_date,
        sales_plan_global_customer_code,
        sales_plan_customer_id,
        sales_plan_customer_name,
        sales_plan_business_type,
        sales_plan_product_global_code,
        sales_plan_poduct_global_name,
        sales_plan_uom,
        sales_plan_quantity,
        sales_plan_quantity_metric_ton,
        sales_plan_group_currency_total_amount,
        sales_plan_home_currency_total_amount,
        sales_plan_budget_currency_total_amount,
        sales_plan_group_currency_cogs1_amount,
        sales_plan_home_currency_cogs1_amount,
        sales_plan_budget_currency_cogs1_amount,
        sales_plan_group_currency_cogs2_amount,
        sales_plan_home_currency_cogs2_amount,
        sales_plan_budget_currency_cogs2_amount,
        sales_plan_home_currency,
        sales_plan_plan_rate,
        sales_plan_industry_type_code,
        sales_plan_customer_code_cgk,
        sales_plan_destination_country,
        sales_plan_currency,
        valid_from,
        valid_to,
        is_current
    FROM {{ ref('sales_plan_dwh') }}
)

SELECT 
    *
FROM sales_plan;
