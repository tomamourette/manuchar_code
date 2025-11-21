-- Auto Generated (Do not modify) 5CD8BF99158A16D4E160815D0831F55426529E75910B400C7E9E48E15DB9F0A6
create view "mim"."bv_brg_sales" as -- First SELECT: Sales Invoices
SELECT 
    -- Date Keys
    CASE 
        WHEN invl.bkey_source = 'DYNAMICS' THEN 
            CASE 
                WHEN inv.sales_invoice_id LIKE '[0-9]%' 
                THEN CAST(inv.sales_invoice_document_date AS DATE)
                ELSE CAST(inv.sales_invoice_date AS DATE) 
            END
        WHEN invl.bkey_source = 'STG_SALES' THEN inv.sales_invoice_date
        ELSE NULL
    END AS bkey_date,
    inv.sales_invoice_closure_date AS closure_date,
    inv.sales_invoice_shipping_date AS shipping_date,

    -- Dimension Keys
    inv.sales_invoice_company AS bkey_company,
    CASE 
        WHEN inv.sales_invoice_company IS NOT NULL 
             AND inv.sales_invoice_ledger_account IS NOT NULL 
             AND CHARINDEX('-', inv.sales_invoice_ledger_account + '-', 9) > 9 
        THEN SUBSTRING(
            inv.sales_invoice_ledger_account, 
            9, 
            CHARINDEX('-', inv.sales_invoice_ledger_account + '-', 9) - 9
        )
        ELSE NULL 
    END AS bkey_cost_center,
    CASE 
        WHEN inv.sales_invoice_company IS NOT NULL 
             AND inv.sales_invoice_ledger_account IS NOT NULL 
             AND CHARINDEX('-', inv.sales_invoice_ledger_account + '-', 9) > 9 
             AND CHARINDEX('-', inv.sales_invoice_ledger_account + '-', 17) > 17
        THEN SUBSTRING(
            inv.sales_invoice_ledger_account, 
            CHARINDEX('-', inv.sales_invoice_ledger_account + '-', 9) + 1, 
            NULLIF(
                CHARINDEX('-', inv.sales_invoice_ledger_account + '-', 17) 
                - LEN(inv.sales_invoice_logistic_id) - 2, 
                0
            )
        )
        ELSE NULL 
    END AS bkey_profit_center,
    CONCAT(UPPER(inv.sales_invoice_company), '_', inv.sales_invoice_customer_id) AS bkey_customer,
    inv.sales_invoice_industry_code AS bkey_customer_industry_invoice,
    CASE 
        WHEN invl.sales_invoice_line_business_unit IS NULL THEN NULL 
        ELSE CONCAT('BU ', invl.sales_invoice_line_business_unit) 
    END AS bkey_business_unit,
    inv.sales_invoice_paymtermid AS bkey_payment_term,
    inv.sales_invoice_destination_country AS bkey_country,
    CASE 
        WHEN inv.sales_invoice_site_id = 'N/A' 
            OR inv.sales_invoice_invent_location = 'N/A' 
            THEN 'N/A'
        WHEN CHARINDEX('/', inv.sales_invoice_invent_location) > 0 
            THEN inv.sales_invoice_site_id + '/' + 
                RIGHT(
                    inv.sales_invoice_invent_location, 
                    CHARINDEX('/', REVERSE(inv.sales_invoice_invent_location)) - 1
                ) 
        ELSE inv.sales_invoice_site_id 
    END AS bkey_site,
    inv.sales_invoice_local_currency_code AS bkey_currency,
    CASE 
        WHEN invl.bkey_source = 'STG_SALES' THEN CONCAT(inv.sales_invoice_company, '_', invl.sales_invoice_line_product_id)
        ELSE invl.sales_invoice_line_product_id 
    END AS bkey_product,
    invl.sales_invoice_line_product_global_code AS bkey_product_global,
    
    -- Numerical Fields
    invl.sales_invoice_line_uom AS uom_original,
    COALESCE(invl.sales_invoice_line_local_amount, 0) AS invoice_amount,
    COALESCE(invl.sales_invoice_line_home_amount, 0) AS home_amount,
    CASE 
        WHEN invl.sales_invoice_line_home_amount IS NOT NULL AND invl.sales_invoice_line_home_amount != 0 
        THEN invl.sales_invoice_line_local_amount / invl.sales_invoice_line_home_amount
        ELSE NULL 
    END AS conversion_rate_local_home,
    COALESCE(invl.sales_invoice_line_quantity, 0) AS invoice_volume_original,
    COALESCE(sales_invoice_line_quantity_mt, 0) AS invoice_volume_mt,
    inv.sales_invoice_order_value AS order_value,
    COALESCE(NULL, 0) AS sales_accrual_amount,
    COALESCE(NULL, 0) AS sales_accrual_volume,
    COALESCE(NULL, 0) AS sales_accrual_volume_mt,
    NULL AS sales_accrual_currency,

    -- COGS specific fields
    ivcg.csv_cogs1_amount,
    ivcg.csv_external_transport_amount,
    ivcg.csv_internal_transport_amount,
    ivcg.csv_other_cogs2_amount,
    ivcg.csv_cogs2_amount,

    -- Budget-specific fields (NULL here)
    NULL AS budget_quantity,
    NULL AS budget_quantity_metric_ton,
    NULL AS budget_amount_group_currency,
    NULL AS budget_amount_home_currency,
    NULL AS budget_amount_budget_currency,
    NULL AS [version],

    -- Forecast-specific fields (NULL here)
    NULL AS forecast_quantity,
    NULL AS forecast_quantity_metric_ton,
    NULL AS forecast_amount_group_currency,
    NULL AS forecast_amount_home_currency,
    NULL AS forecast_amount_forecast_currency,

    -- Fact Fields
    inv.sales_invoice_customer_vat AS legal_number,
    inv.sales_invoice_id AS invoice_number,
    invl.sales_invoice_line_invoice_line_num AS invoice_line_number,
    CASE
        WHEN LEFT(RIGHT(inv.sales_invoice_id, 11), 3) IN ('ICN', 'SPC') THEN inv.sales_invoice_id
        WHEN LEFT(RIGHT(inv.sales_invoice_id, 10), 2) = 'CN' THEN inv.sales_invoice_id
        ELSE NULL
    END AS credit_note_id,
    invl.bkey_source,
    'Actual' AS actual_budget

FROM "dbb_warehouse"."mim"."bv_sales_invoice_line" invl 
LEFT JOIN "dbb_warehouse"."mim"."bv_sales_invoice" inv
    ON inv.bkey_sales_invoice = invl.bkey_sales_invoice
LEFT JOIN "dbb_warehouse"."mim"."bv_sales_invoice_line_cogs" ivcg
    ON invl.bkey_sales_invoice_line = ivcg.bkey_sales_invoice_line_cogs
WHERE invl.bkey_source IN ('DYNAMICS', 'STG_SALES') AND inv.is_current = 1

UNION ALL

-- Second SELECT: Sales Orders (Accruals)
SELECT 
    sales_order_sales_accrual_accounting_date AS bkey_date,
    NULL AS closure_date,
    NULL AS shipping_date,
    sales_order_company AS bkey_company,
    CASE 
        WHEN sales_order_company IS NOT NULL 
             AND sales_order_ledger_account IS NOT NULL 
             AND CHARINDEX('-', sales_order_ledger_account + '-', 9) > 9 
        THEN SUBSTRING(
            sales_order_ledger_account, 
            9, 
            CHARINDEX('-', sales_order_ledger_account + '-', 9) - 9
        )
        ELSE NULL 
    END AS bkey_cost_center,
    sales_order_procen_value AS bkey_profit_center,
    CONCAT(sales_order_company, '_', sales_order_cust_account) AS bkey_customer,
    NULL AS bkey_customer_industry_invoice,
    NULL AS bkey_business_unit,
    NULL AS bkey_payment_term,
    NULL AS bkey_country,
    NULL AS bkey_site,
    NULL AS bkey_currency,
    NULL AS bkey_product,
    NULL AS bkey_product_global,

    -- Numerical Fields
    NULL AS uom_original,
    COALESCE(NULL, 0) AS invoice_amount,
    COALESCE(NULL, 0) AS home_amount,
    NULL AS conversion_rate_local_home,
    COALESCE(NULL, 0) AS invoice_volume_original,
    COALESCE(NULL, 0) AS invoice_volume_mt,
    sales_order_sales_id AS order_value,
    COALESCE(sales_order_sales_amount_accrual, 0) AS sales_accrual_amount,
    COALESCE(sales_order_sales_volume_accrual, 0) AS sales_accrual_volume,
    COALESCE(sales_order_sales_volume_mt_accrual, 0) AS sales_accrual_volume_mt,
    
    sales_order_currencycode AS sales_accrual_currency,

    -- COGS specific fields
    NULL AS csv_cogs1_amount,
    NULL AS csv_external_transport_amount,
    NULL AS csv_internal_transport_amount,
    NULL AS csv_other_cogs2_amount,
    NULL AS csv_cogs2_amount,

    -- Budget-specific fields (NULL here)
    NULL AS budget_quantity,
    NULL AS budget_quantity_metric_ton,
    NULL AS budget_amount_group_currency,
    NULL AS budget_amount_home_currency,
    NULL AS budget_amount_budget_currency,
    NULL AS [version],

    -- Forecast-specific fields (NULL here)
    NULL AS forecast_quantity,
    NULL AS forecast_quantity_metric_ton,
    NULL AS forecast_amount_group_currency,
    NULL AS forecast_amount_home_currency,
    NULL AS forecast_amount_forecast_currency,

    -- Fact Fields
    NULL AS legal_number,
    NULL AS invoice_number,
    NULL AS invoice_line_number,
    NULL AS credit_note_id,
    bkey_source,
    'Accruals' AS actual_budget

FROM "dbb_warehouse"."mim"."bv_sales_order"

UNION ALL

-- Third SELECT: Budget
SELECT DISTINCT
    sp.sales_plan_closure_date AS bkey_date,
    sp.sales_plan_closure_date AS closure_date,
    NULL AS shipping_date,
    sp.sales_plan_company AS bkey_company,
    NULL AS bkey_cost_center,
    NULL AS bkey_profit_center,
    CONCAT(sp.sales_plan_company, '_', sp.sales_plan_customer_id) AS bkey_customer,
    sp.sales_plan_industry_type_code AS bkey_customer_industry_invoice,
    NULL AS bkey_business_unit,
    NULL AS bkey_payment_term,
    sp.sales_plan_destination_country AS bkey_country,
    NULL AS bkey_site,
    sp.sales_plan_currency AS bkey_currency,
    NULL AS bkey_product, -- no link to local product for Sales Budget & Forecast
    sp.sales_plan_product_global_code AS bkey_product_global,

    -- Numerical Fields
    sp.sales_plan_uom AS uom_original,
    NULL AS invoice_amount,
    NULL AS home_amount,
    NULL AS conversion_rate_local_home,
    NULL AS invoice_volume_original,
    NULL AS invoice_volume_mt,
    NULL AS order_value,
    NULL AS sales_accrual_amount,
    NULL AS sales_accrual_volume,
    NULL AS sales_accrual_volume_mt,
    NULL AS sales_accrual_currency,

    -- COGS specific fields
    NULL AS csv_cogs1_amount,
    NULL AS csv_external_transport_amount,
    NULL AS csv_internal_transport_amount,
    NULL AS csv_other_cogs2_amount,
    NULL AS csv_cogs2_amount,

    -- Budget/Forecast-specific fields
    COALESCE(sales_plan_quantity, 0) AS budget_quantity,
    COALESCE(sales_plan_quantity_metric_ton, 0) AS budget_quantity_metric_ton,
    COALESCE(sales_plan_group_currency_total_amount, 0) AS budget_amount_group_currency,
    COALESCE(sales_plan_home_currency_total_amount, 0) AS budget_amount_home_currency,
    COALESCE(sales_plan_budget_currency_total_amount, 0) AS budget_amount_budget_currency,
    sp.sales_plan_version AS [version],

    -- Forecast-specific fields (NULL here)
    NULL AS forecast_quantity,
    NULL AS forecast_quantity_metric_ton,
    NULL AS forecast_amount_group_currency,
    NULL AS forecast_amount_home_currency,
    NULL AS forecast_amount_forecast_currency,

    -- Fact Fields
    NULL AS legal_number,
    NULL AS invoice_number,
    NULL AS invoice_line_number,
    NULL AS credit_note_id,
    'DWH' AS bkey_source,
    'Budget' AS actual_budget

FROM "dbb_warehouse"."mim"."bv_sales_plan" sp
INNER JOIN (
	SELECT
		MAX(sales_plan_version) AS sales_plan_version,
		sales_plan_closure_date,
		sales_plan_category
	FROM "dbb_warehouse"."mim"."bv_sales_plan"
	WHERE sales_plan_category = 'Budget'
	GROUP BY sales_plan_closure_date, sales_plan_category
) sp_max
ON sp.sales_plan_version = sp_max.sales_plan_version
   AND sp.sales_plan_closure_date = sp_max.sales_plan_closure_date
   AND sp.sales_plan_category = sp_max.sales_plan_category


UNION ALL

-- Fourth SELECT: Forecast
SELECT 
    sat.sales_plan_closure_date AS bkey_date,
    sat.sales_plan_closure_date AS closure_date,
    NULL AS shipping_date,
    sat.sales_plan_company AS bkey_company,
    NULL AS bkey_cost_center,
    NULL AS bkey_profit_center,
    CONCAT(sat.sales_plan_company, '_', sat.sales_plan_customer_id) AS bkey_customer,
    sat.sales_plan_industry_type_code AS bkey_customer_industry_invoice,
    NULL AS bkey_business_unit,
    NULL AS bkey_payment_term,
    sat.sales_plan_destination_country AS bkey_country,
    NULL AS bkey_site,
    sat.sales_plan_currency AS bkey_currency,
    NULL AS bkey_product, -- no link to local product for Sales Budget & Forecast
    sat.sales_plan_product_global_code AS bkey_product_global,

    -- Numerical Fields
    sat.sales_plan_uom AS uom_original,
    NULL AS invoice_amount,
    NULL AS home_amount,
    NULL AS conversion_rate_local_home,
    NULL AS invoice_volume_original,
    NULL AS invoice_volume_mt,
    NULL AS order_value,
    NULL AS sales_accrual_amount,
    NULL AS sales_accrual_volume,
    NULL AS sales_accrual_volume_mt,
    NULL AS sales_accrual_currency,

    -- COGS specific fields
    NULL AS csv_cogs1_amount,
    NULL AS csv_external_transport_amount,
    NULL AS csv_internal_transport_amount,
    NULL AS csv_other_cogs2_amount,
    NULL AS csv_cogs2_amount,

    -- Budget/Forecast-specific fields
    NULL AS budget_quantity,
    NULL AS budget_quantity_metric_ton,
    NULL AS budget_amount_group_currency,
    NULL AS budget_amount_home_currency,
    NULL AS budget_amount_budget_currency,
    sat.sales_plan_version AS [version],

    COALESCE(sales_plan_quantity, 0) AS forecast_quantity,
    COALESCE(sales_plan_quantity_metric_ton, 0) AS forecast_quantity_metric_ton,
    COALESCE(sales_plan_group_currency_total_amount, 0) AS forecast_amount_group_currency,
    COALESCE(sales_plan_home_currency_total_amount, 0) AS forecast_amount_home_currency,
    COALESCE(sales_plan_budget_currency_total_amount, 0) AS forecast_amount_forecast_currency,

    -- Fact Fields
    NULL AS legal_number,
    NULL AS invoice_number,
    NULL AS invoice_line_number,
    NULL AS credit_note_id,
    'DWH' AS bkey_source,
    'Forecast' AS actual_budget

FROM "dbb_warehouse"."mim"."bv_sales_plan" sat
INNER JOIN (
	SELECT
		MAX(sales_plan_version) AS sales_plan_version,
		sales_plan_closure_date,
		sales_plan_category
	FROM "dbb_warehouse"."mim"."bv_sales_plan"
	WHERE sales_plan_category = 'Forecast'
	GROUP BY sales_plan_closure_date, sales_plan_category
) sp_max
ON sat.sales_plan_version = sp_max.sales_plan_version
   AND sat.sales_plan_closure_date = sp_max.sales_plan_closure_date
   AND sat.sales_plan_category = sp_max.sales_plan_category;