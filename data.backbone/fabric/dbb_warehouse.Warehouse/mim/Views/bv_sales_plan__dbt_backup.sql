-- Auto Generated (Do not modify) B8C05433B4824262A40AD1B676876C2728CF93DE8BB1AD43C6ACF35249B29473
create view "mim"."bv_sales_plan" as WITH sales_plan AS (
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
        sat.sales_plan_home_currency,
        sat.sales_plan_plan_rate,
        sat.sales_plan_industry_type_code,
        sat.sales_plan_customer_code_cgk,
        sat.sales_plan_destination_country,
        sat.sales_plan_currency,

        -- Total Amount
        sales_plan_total_amount_trans_cur,
        sales_plan_total_amount_func_cur,
        sales_plan_total_amount_group_cur,
        -- COGS1 Amount
        sales_plan_cogs1_amount_trans_cur,
        sales_plan_cogs1_amount_func_cur,
        sales_plan_cogs1_amount_group_cur,
        -- COGS2 Amount
        sales_plan_cogs2_amount_trans_cur,
        sales_plan_cogs2_amount_func_cur,
        sales_plan_cogs2_amount_group_cur,

        sat.valid_from,
        sat.valid_to,
        sat.is_current
    FROM "dbb_warehouse"."mim"."rv_hub_sales_plan" hub
    LEFT JOIN "dbb_warehouse"."mim"."rv_sat_sales_plan" sat 
        ON hub.bkey_sales_plan_source = sat.bkey_sales_plan_source
)

SELECT 
    *
FROM sales_plan;;