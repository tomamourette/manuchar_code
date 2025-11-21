-- Auto Generated (Do not modify) A31CB46AA450E7B489D456DA33DE7923A73BACE6449ABE1F99799C947213B092
create view "mim"."bv_brg_sales_monthly" as -- First SELECT: Sales Invoices
SELECT 
    -- Date Keys
    inv.sales_invoice_date AS invoice_date,
    inv.sales_invoice_closure_date AS closure_date,
    inv.sales_invoice_shipping_date AS shipping_date,

    -- Dimension Keys
    inv.sales_invoice_company AS bkey_company,
    CONCAT(UPPER(inv.sales_invoice_company), '_', inv.sales_invoice_customer_id) AS bkey_customer,
    inv.sales_invoice_industry_code AS bkey_customer_industry_invoice,
    CONCAT('BU ', invlc.sales_invoice_line_cogs_business_unit) AS bkey_business_unit,
    inv.sales_invoice_paymtermid AS bkey_payment_term,
    inv.sales_invoice_destination_country AS bkey_destination_country,
    inv.sales_invoice_site_id AS bkey_site,
    inv.sales_invoice_local_currency_code AS bkey_currency,
    CONCAT(inv.sales_invoice_company, '_', invlc.sales_invoice_line_cogs_product_id) AS bkey_product,
    invlc.sales_invoice_line_cogs_product_global_code AS bkey_product_global,
    
    -- Numerical Fields
    
    --------------------------------------------------------------------------------
    -- Sales Revenue
    --------------------------------------------------------------------------------
    invlc.sales_invoice_line_amount_trans_cur,
    invlc.sales_invoice_line_amount_func_cur,
    invlc.sales_invoice_line_amount_group_cur_conso_avg,

	--------------------------------------------------------------------------------
	-- COGS1 - Purchase / Freight / Other
	--------------------------------------------------------------------------------
    invlc.cogs1_costofgood_amount_func_cur,
    invlc.cogs1_costofgood_amount_trans_cur,
    invlc.cogs1_costofgood_amount_conso_avg,

    invlc.cogs1_freight_amount_funccur,
    invlc.sfreight_amount_transcur,
    invlc.cogs1_freight_amount_groupcur_conso_avg,

    invlc.cogs1_other_amount_funccur,
    invlc.cogs1_other_amount_transcur,
    invlc.cogs1_other_amount_groupcur_conso_avg,

    -- COGS 1 - Total
    invlc.total_cogs1_amount_func_cur,
    invlc.total_cogs1_amount_trans_cur,
    invlc.total_cogs1_amount_group_conso_avg,
    --------------------------------------------------------------------------------
	-- COGS2 - Transport en Other
	--------------------------------------------------------------------------------
    invlc.cogs2_transport_external_amount_func_cur,
    invlc.cogs2_transport_external_amount_trans_cur,
    invlc.cogs2_transport_external_amount_group_conso_avg,

    invlc.cogs2_transport_internal_amount_func_cur,
    invlc.cogs2_transport_internal_amount_trans_cur,
    invlc.cogs2_transport_internal_amount_group_conso_avg,

    invlc.cogs2_other_amount_func_cur,
    invlc.cogs2_other_amount_trans_cur,
    invlc.cogs2_other_amount_group_conso_avg,
    -- COGS2 - Total
    invlc.total_cogs2_amount_func_cur,  
    invlc.total_cogs2_amount_trans_cur,
    invlc.total_cogs2_amount_group_conso_avg,

    --------------------------------------------------------------------------------
	-- Accrual Amounts
	--------------------------------------------------------------------------------
    NULL AS sales_accrual_amount_trans_cur,
    NULL AS sales_accrual_amount_func_cur,
    NULL AS sales_accrual_amount_group_cur_conso_avg,

    --------------------------------------------------------------------------------
	-- Budget Amounts
	--------------------------------------------------------------------------------
    -- Total Amount
    NULL AS budget_amount_trans_cur,
    NULL AS budget_amount_func_cur,
    NULL AS budget_amount_group_cur,
    -- COGS1 Amount
    NULL AS budget_cogs1_amount_trans_cur,
    NULL AS budget_cogs1_amount_func_cur,
    NULL AS budget_cogs1_amount_group_cur,
    -- COGS2 Amount
    NULL AS budget_cogs2_amount_trans_cur,
    NULL AS budget_cogs2_amount_func_cur,
    NULL AS budget_cogs2_amount_group_cur,

    --------------------------------------------------------------------------------
	-- Forecast Amounts
	--------------------------------------------------------------------------------
    -- Total Amount
    NULL AS forecast_amount_trans_cur,
    NULL AS forecast_amount_func_cur,
    NULL AS forecast_amount_group_cur,
    -- COGS1 Amount
    NULL AS forecast_cogs1_amount_trans_cur,
    NULL AS forecast_cogs1_amount_func_cur,
    NULL AS forecast_cogs1_amount_group_cur,
    -- COGS2 Amount
    NULL AS forecast_cogs2_amount_trans_cur,
    NULL AS forecast_cogs2_amount_func_cur,
    NULL AS forecast_cogs2_amount_group_cur,
    
    --------------------------------------------------------------------------------
	-- Volume Amounts
	--------------------------------------------------------------------------------
    COALESCE(invlc.sales_invoice_line_cogs_quantity, 0) AS invoice_volume_original,
    COALESCE(invlc.sales_invoice_line_cogs_quantity_mt, 0) AS invoice_volume_mt,

    -- Fact Fields
    inv.sales_invoice_order_value AS order_value,
    invlc.sales_invoice_line_cogs_uom AS sales_uom_original,
    inv.sales_invoice_id AS invoice_number,
    invlc.sales_invoice_line_cogs_line_number AS invoice_line_number,
    CASE
        WHEN LEFT(RIGHT(inv.sales_invoice_id, 11), 3) IN ('ICN', 'SPC') THEN inv.sales_invoice_id
        WHEN LEFT(RIGHT(inv.sales_invoice_id, 10), 2) = 'CN' THEN inv.sales_invoice_id
        ELSE NULL
    END AS credit_note_id,
    invlc.bkey_source,
    'Actual' AS actual_budget

FROM "dbb_warehouse"."mim"."bv_sales_invoice_line_cogs" invlc
LEFT JOIN "dbb_warehouse"."mim"."bv_sales_invoice" inv
    ON inv.bkey_sales_invoice = invlc.bkey_sales_invoice
WHERE inv.bkey_source IN ('STG_SALES', 'DYNAMICS') 
AND inv.is_current = 1

UNION ALL

-- Second SELECT: Sales Orders (Accruals)
SELECT 
    -- Date Keys
    sales_order_sales_accrual_accounting_date AS invoice_date,
    NULL AS closure_date,
    NULL AS shipping_date,

    -- Dimension Keys
    sales_order_company AS bkey_company,
    CONCAT(sales_order_company, '_', sales_order_cust_account) AS bkey_customer,
    NULL AS bkey_customer_industry_invoice,
    NULL AS bkey_business_unit,
    NULL AS bkey_payment_term,
    NULL AS bkey_destination_country,
    NULL AS bkey_site,
    sales_order_currencycode AS bkey_currency,
    NULL AS bkey_product,
    NULL AS bkey_product_global,

    -- Numerical Fields
    
    --------------------------------------------------------------------------------
    -- Sales Revenue
    --------------------------------------------------------------------------------
    NULL AS sales_invoice_line_amount_trans_cur,
    NULL AS sales_invoice_line_amount_func_cur,
    NULL AS sales_invoice_line_amount_group_cur_conso_avg,

	--------------------------------------------------------------------------------
	-- COGS1 - Purchase / Freight / Other
	--------------------------------------------------------------------------------
    NULL AS cogs1_costofgood_amount_func_cur,
    NULL AS cogs1_costofgood_amount_trans_cur,
    NULL AS cogs1_costofgood_amount_conso_avg,

    NULL AS cogs1_freight_amount_funccur,
    NULL AS sfreight_amount_transcur,
    NULL AS cogs1_freight_amount_groupcur_conso_avg,

    NULL AS cogs1_other_amount_funccur,
    NULL AS cogs1_other_amount_transcur,
    NULL AS cogs1_other_amount_groupcur_conso_avg,

    -- COGS 1 - Total
    NULL AS total_cogs1_amount_func_cur,
    NULL AS total_cogs1_amount_trans_cur,
    NULL AS total_cogs1_amount_group_conso_avg,    
    --------------------------------------------------------------------------------
	-- COGS2 - Transport en Other
	--------------------------------------------------------------------------------
    NULL AS cogs2_transport_external_amount_func_cur,
    NULL AS cogs2_transport_external_amount_trans_cur,
    NULL AS cogs2_transport_external_amount_group_conso_avg,

    NULL AS cogs2_transport_internal_amount_func_cur,
    NULL AS cogs2_transport_internal_amount_trans_cur,
    NULL AS cogs2_transport_internal_amount_group_conso_avg,

    NULL AS cogs2_other_amount_func_cur,
    NULL AS cogs2_other_amount_trans_cur,
    NULL AS cogs2_other_amount_group_conso_avg,
    -- COGS2 - Total
    NULL AS total_cogs2_amount_func_cur,  
    NULL AS total_cogs2_amount_trans_cur,
    NULL AS total_cogs2_amount_group_conso_avg,
    
    --------------------------------------------------------------------------------
	-- Accrual Amounts
	--------------------------------------------------------------------------------
    sales_accrual_amount_trans_cur,
    sales_accrual_amount_func_cur,
    sales_accrual_amount_group_cur_conso_avg,

    --------------------------------------------------------------------------------
	-- Budget Amounts
	--------------------------------------------------------------------------------
    -- Total Amount
    NULL AS budget_amount_trans_cur,
    NULL AS budget_amount_func_cur,
    NULL AS budget_amount_group_cur,
    -- COGS1 Amount
    NULL AS budget_cogs1_amount_trans_cur,
    NULL AS budget_cogs1_amount_func_cur,
    NULL AS budget_cogs1_amount_group_cur,
    -- COGS2 Amount
    NULL AS budget_cogs2_amount_trans_cur,
    NULL AS budget_cogs2_amount_func_cur,
    NULL AS budget_cogs2_amount_group_cur,

    --------------------------------------------------------------------------------
	-- Forecast Amounts
	--------------------------------------------------------------------------------
    -- Total Amount
    NULL AS forecast_amount_trans_cur,
    NULL AS forecast_amount_func_cur,
    NULL AS forecast_amount_group_cur,
    -- COGS1 Amount
    NULL AS forecast_cogs1_amount_trans_cur,
    NULL AS forecast_cogs1_amount_func_cur,
    NULL AS forecast_cogs1_amount_group_cur,
    -- COGS2 Amount
    NULL AS forecast_cogs2_amount_trans_cur,
    NULL AS forecast_cogs2_amount_func_cur,
    NULL AS forecast_cogs2_amount_group_cur,
    
    --------------------------------------------------------------------------------
	-- Volume Amounts
	--------------------------------------------------------------------------------
    COALESCE(sales_order_sales_volume_accrual, 0) AS invoice_volume_original,
    COALESCE(sales_order_sales_volume_mt_accrual, 0) AS invoice_volume_mt,
    
    -- Fact Fields
    sales_order_sales_id AS order_value,
    NULL AS sales_uom_original,
    NULL AS invoice_number,
    NULL AS invoice_line_number,
    NULL AS credit_note_id,
    bkey_source,
    'Accruals' AS actual_budget

FROM "dbb_warehouse"."mim"."bv_sales_order"

UNION ALL

-- Third SELECT: Budget
SELECT 
    -- Date Keys
    sp.sales_plan_closure_date AS invoice_date,
    sp.sales_plan_closure_date AS closure_date,
    NULL AS shipping_date,

    -- Dimension Keys
    sp.sales_plan_company AS bkey_company,
    CONCAT(sp.sales_plan_company, '_', sp.sales_plan_customer_id) AS bkey_customer,
    sp.sales_plan_industry_type_code AS bkey_customer_industry_invoice,
    NULL AS bkey_business_unit,
    NULL AS bkey_payment_term,
    sp.sales_plan_destination_country AS bkey_destination_country,
    NULL AS bkey_site,
    sp.sales_plan_currency AS bkey_currency,
    NULL AS bkey_product, -- no link to local product for Sales Budget & Forecast
    sp.sales_plan_product_global_code AS bkey_product_global,

    -- Numerical Fields
    
    --------------------------------------------------------------------------------
    -- Sales Revenue
    --------------------------------------------------------------------------------
    NULL AS sales_invoice_line_amount_trans_cur,
    NULL AS sales_invoice_line_amount_func_cur,
    NULL AS sales_invoice_line_amount_group_cur_conso_avg,

	--------------------------------------------------------------------------------
	-- COGS1 - Purchase / Freight / Other
	--------------------------------------------------------------------------------
    NULL AS cogs1_costofgood_amount_func_cur,
    NULL AS cogs1_costofgood_amount_trans_cur,
    NULL AS cogs1_costofgood_amount_conso_avg,

    NULL AS cogs1_freight_amount_funccur,
    NULL AS sfreight_amount_transcur,
    NULL AS cogs1_freight_amount_groupcur_conso_avg,

    NULL AS cogs1_other_amount_funccur,
    NULL AS cogs1_other_amount_transcur,
    NULL AS cogs1_other_amount_groupcur_conso_avg,

    -- COGS 1 - Total
    NULL AS total_cogs1_amount_func_cur,
    NULL AS total_cogs1_amount_trans_cur,
    NULL AS total_cogs1_amount_group_conso_avg,
    --------------------------------------------------------------------------------
	-- COGS2 - Transport en Other
	--------------------------------------------------------------------------------
    NULL AS cogs2_transport_external_amount_func_cur,
    NULL AS cogs2_transport_external_amount_trans_cur,
    NULL AS cogs2_transport_external_amount_group_conso_avg,

    NULL AS cogs2_transport_internal_amount_func_cur,
    NULL AS cogs2_transport_internal_amount_trans_cur,
    NULL AS cogs2_transport_internal_amount_group_conso_avg,

    NULL AS cogs2_other_amount_func_cur,
    NULL AS cogs2_other_amount_trans_cur,
    NULL AS cogs2_other_amount_group_conso_avg,
    -- COGS2 - Total
    NULL AS total_cogs2_amount_func_cur,  
    NULL AS total_cogs2_amount_trans_cur,
    NULL AS total_cogs2_amount_group_conso_avg,
    
    --------------------------------------------------------------------------------
	-- Accrual Amounts
	--------------------------------------------------------------------------------
    NULL AS sales_accrual_amount_trans_cur,
    NULL AS sales_accrual_amount_func_cur,
    NULL AS sales_accrual_amount_group_cur_conso_avg,

    --------------------------------------------------------------------------------
	-- Budget Amounts
	--------------------------------------------------------------------------------
    -- Total Amount
    sales_plan_total_amount_trans_cur AS budget_amount_trans_cur,
    sales_plan_total_amount_func_cur AS budget_amount_func_cur,
    sales_plan_total_amount_group_cur AS budget_amount_group_cur,
    -- COGS1 Amount
    sales_plan_cogs1_amount_trans_cur AS budget_cogs1_amount_trans_cur,
    sales_plan_cogs1_amount_func_cur AS budget_cogs1_amount_func_cur,
    sales_plan_cogs1_amount_group_cur AS budget_cogs1_amount_group_cur,
    -- COGS2 Amount
    sales_plan_cogs2_amount_trans_cur AS budget_cogs2_amount_trans_cur,
    sales_plan_cogs2_amount_func_cur AS budget_cogs2_amount_func_cur,
    sales_plan_cogs2_amount_group_cur AS budget_cogs2_amount_group_cur,

    --------------------------------------------------------------------------------
	-- Forecast Amounts
	--------------------------------------------------------------------------------
    -- Total Amount
    NULL AS forecast_amount_trans_cur,
    NULL AS forecast_amount_func_cur,
    NULL AS forecast_amount_group_cur,
    -- COGS1 Amount
    NULL AS forecast_cogs1_amount_trans_cur,
    NULL AS forecast_cogs1_amount_func_cur,
    NULL AS forecast_cogs1_amount_group_cur,
    -- COGS2 Amount
    NULL AS forecast_cogs2_amount_trans_cur,
    NULL AS forecast_cogs2_amount_func_cur,
    NULL AS forecast_cogs2_amount_group_cur,
    
    --------------------------------------------------------------------------------
	-- Volume Amounts
	--------------------------------------------------------------------------------
    NULL AS invoice_volume_original,
    NULL AS invoice_volume_mt,
    
    -- Fact Fields
    NULL AS order_value,
    sp.sales_plan_uom AS sales_uom_original,
    NULL AS invoice_number,
    NULL AS invoice_line_number,
    NULL AS credit_note_id,
    sp.bkey_source,
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
    -- Date Keys
    sp.sales_plan_closure_date AS invoice_date,
    sp.sales_plan_closure_date AS closure_date,
    NULL AS shipping_date,

    -- Dimension Keys
    sp.sales_plan_company AS bkey_company,
    CONCAT(sp.sales_plan_company, '_', sp.sales_plan_customer_id) AS bkey_customer,
    sp.sales_plan_industry_type_code AS bkey_customer_industry_invoice,
    NULL AS bkey_business_unit,
    NULL AS bkey_payment_term,
    sp.sales_plan_destination_country AS bkey_destination_country,
    NULL AS bkey_site,
    sp.sales_plan_currency AS bkey_currency,
    NULL AS bkey_product, -- no link to local product for Sales Budget & Forecast
    sp.sales_plan_product_global_code AS bkey_product_global,

    -- Numerical Fields
    
    --------------------------------------------------------------------------------
    -- Sales Revenue
    --------------------------------------------------------------------------------
    NULL AS sales_invoice_line_amount_trans_cur,
    NULL AS sales_invoice_line_amount_func_cur,
    NULL AS sales_invoice_line_amount_group_cur_conso_avg,

	--------------------------------------------------------------------------------
	-- COGS1 - Purchase / Freight / Other
	--------------------------------------------------------------------------------
    NULL AS cogs1_costofgood_amount_func_cur,
    NULL AS cogs1_costofgood_amount_trans_cur,
    NULL AS cogs1_costofgood_amount_conso_avg,

    NULL AS cogs1_freight_amount_funccur,
    NULL AS sfreight_amount_transcur,
    NULL AS cogs1_freight_amount_groupcur_conso_avg,

    NULL AS cogs1_other_amount_funccur,
    NULL AS cogs1_other_amount_transcur,
    NULL AS cogs1_other_amount_groupcur_conso_avg,

    -- COGS 1 - Total
    NULL AS total_cogs1_amount_func_cur,
    NULL AS total_cogs1_amount_trans_cur,
    NULL AS total_cogs1_amount_group_conso_avg,
    --------------------------------------------------------------------------------
	-- COGS2 - Transport en Other
	--------------------------------------------------------------------------------
    NULL AS cogs2_transport_external_amount_func_cur,
    NULL AS cogs2_transport_external_amount_trans_cur,
    NULL AS cogs2_transport_external_amount_group_conso_avg,

    NULL AS cogs2_transport_internal_amount_func_cur,
    NULL AS cogs2_transport_internal_amount_trans_cur,
    NULL AS cogs2_transport_internal_amount_group_conso_avg,

    NULL AS cogs2_other_amount_func_cur,
    NULL AS cogs2_other_amount_trans_cur,
    NULL AS cogs2_other_amount_group_conso_avg,
    -- COGS2 - Total
    NULL AS total_cogs2_amount_func_cur,  
    NULL AS total_cogs2_amount_trans_cur,
    NULL AS total_cogs2_amount_group_conso_avg,
    
    --------------------------------------------------------------------------------
	-- Accrual Amounts
	--------------------------------------------------------------------------------
    NULL AS sales_accrual_amount_trans_cur,
    NULL AS sales_accrual_amount_func_cur,
    NULL AS sales_accrual_amount_group_cur_conso_avg,

    --------------------------------------------------------------------------------
	-- Budget Amounts
	--------------------------------------------------------------------------------
    -- Total Amount
    NULL AS budget_amount_trans_cur,
    NULL AS budget_amount_func_cur,
    NULL AS budget_amount_group_cur,
    -- COGS1 Amount
    NULL AS budget_cogs1_amount_trans_cur,
    NULL AS budget_cogs1_amount_func_cur,
    NULL AS budget_cogs1_amount_group_cur,
    -- COGS2 Amount
    NULL AS budget_cogs2_amount_trans_cur,
    NULL AS budget_cogs2_amount_func_cur,
    NULL AS budget_cogs2_amount_group_cur,

    --------------------------------------------------------------------------------
	-- Forecast Amounts
	--------------------------------------------------------------------------------
    -- Total Amount
    sales_plan_total_amount_trans_cur AS forecast_amount_trans_cur,
    sales_plan_total_amount_func_cur AS forecast_amount_func_cur,
    sales_plan_total_amount_group_cur AS forecast_amount_group_cur,
    -- COGS1 Amount
    sales_plan_cogs1_amount_trans_cur AS forecast_cogs1_amount_trans_cur,
    sales_plan_cogs1_amount_func_cur AS forecast_cogs1_amount_func_cur,
    sales_plan_cogs1_amount_group_cur AS forecast_cogs1_amount_group_cur,
    -- COGS2 Amount
    sales_plan_cogs2_amount_trans_cur AS forecast_cogs2_amount_trans_cur,
    sales_plan_cogs2_amount_func_cur AS forecast_cogs2_amount_func_cur,
    sales_plan_cogs2_amount_group_cur AS forecast_cogs2_amount_group_cur,
    
    --------------------------------------------------------------------------------
	-- Volume Amounts
	--------------------------------------------------------------------------------
    NULL AS invoice_volume_original,
    NULL AS invoice_volume_mt,
    
    -- Fact Fields
    NULL AS order_value,
    sp.sales_plan_uom AS sales_uom_original,
    NULL AS invoice_number,
    NULL AS invoice_line_number,
    NULL AS credit_note_id,
    sp.bkey_source,
    'Forecast' AS actual_budget

FROM "dbb_warehouse"."mim"."bv_sales_plan" sp
INNER JOIN (
	SELECT
		MAX(sales_plan_version) AS sales_plan_version,
		sales_plan_closure_date,
		sales_plan_category
	FROM "dbb_warehouse"."mim"."bv_sales_plan"
	WHERE sales_plan_category = 'Forecast'
	GROUP BY sales_plan_closure_date, sales_plan_category
) sp_max
ON sp.sales_plan_version = sp_max.sales_plan_version
   AND sp.sales_plan_closure_date = sp_max.sales_plan_closure_date
   AND sp.sales_plan_category = sp_max.sales_plan_category;