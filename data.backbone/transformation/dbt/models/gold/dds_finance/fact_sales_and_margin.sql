SELECT 
    -- Date keys
    dat.tkey_date AS tkey_invoice_date,
    clod.tkey_date AS tkey_closuredate,
    shid.tkey_date AS tkey_shippingdate,

    -- Dimension keys
    com.tkey_company,
    cur.tkey_currency,
    cou.tkey_country,
    cus.tkey_customer,
    prod.tkey_product,
    prog.tkey_product_global,
    pay.tkey_payment_term,
    bu.tkey_business_unit,
    ci.tkey_customer_industry_invoice,
    cc.tkey_cost_center,
    pc.tkey_cost_center AS tkey_profit_center,
    src_ds.tkey_site,

    -- Fact attributes
    --brg.closure_date,
    brg.invoice_number,
    brg.invoice_line_number,
    brg.credit_note_id,
    brg.uom_original,
    brg.order_value,
    brg.actual_budget,
    brg.bkey_source,

    -- Measures
    SUM(brg.invoice_amount) AS invoice_amount,
    SUM(brg.invoice_volume_original) AS invoice_volume_original,
    SUM(brg.invoice_volume_mt) AS invoice_volume_mt,
    SUM(brg.sales_accrual_amount) AS sales_accrual_amount,
    SUM(brg.sales_accrual_volume) AS sales_accrual_volume,
    SUM(brg.sales_accrual_volume_mt) AS sales_accrual_volume_mt,
    
    -- SUM(brg.cogs1_amount) AS cogs1_amount,
    -- SUM(brg.cogs1_purchase_amount) AS cogs1_purchase_amount,
    -- SUM(brg.cogs1_freight_amount) AS cogs1_freight_amount,
    -- SUM(brg.cogs1_other_amount) AS cogs1_other_amount,
    -- SUM(brg.cogs2_amount) AS cogs2_amount,
    -- SUM(brg.cogs2_transport_internal_amount) AS cogs2_transport_internal_amount,
    -- SUM(brg.cogs2_transport_external_amount) AS cogs2_transport_external_amount,
    -- SUM(brg.cogs_adjusted_amount) AS cogs_adjusted_amount,

    -- COGS
    SUM(brg.csv_cogs1_amount) AS csv_cogs1_amount,
    SUM(brg.csv_external_transport_amount) AS csv_external_transport_amount,
    SUM(brg.csv_internal_transport_amount) AS csv_internal_transport_amount,
    SUM(brg.csv_other_cogs2_amount) AS csv_other_cogs2_amount,
    SUM(brg.csv_cogs2_amount) AS csv_cogs2_amount,

    --Budget Measures
    SUM(brg.budget_quantity) AS budget_quantity,
    SUM(brg.budget_quantity_metric_ton) AS budget_quantity_metric_ton,
    SUM(brg.budget_amount_group_currency) AS budget_amount_group_currency,
    SUM(brg.budget_amount_home_currency) AS budget_amount_home_currency,
    SUM(brg.budget_amount_budget_currency) AS budget_amount_budget_currency,

    brg.version AS [version],

    SUM(brg.forecast_quantity) AS forecast_quantity,
    SUM(brg.forecast_quantity_metric_ton) AS forecast_quantity_metric_ton,
    SUM(brg.forecast_amount_group_currency) AS forecast_amount_group_currency,
    SUM(brg.forecast_amount_home_currency) AS forecast_amount_home_currency,
    SUM(brg.forecast_amount_forecast_currency) AS forecast_amount_forecast_currency,


    -- Currency Rates
    MAX(lgc.currency_rate_closing_rate / hgc.currency_rate_closing_rate) AS conversion_rate_local_home,
    MAX(lgc.currency_rate_closing_rate) AS conversion_rate_local_group



FROM {{ ref('bv_brg_sales') }} AS brg

-- Date joins
LEFT JOIN {{ ref('dim_date') }} dat 
    ON dat.date = brg.bkey_date
--to do change it to date 
--CAST(CONVERT(VARCHAR(8), brg.bkey_date, 112) AS INT)
 LEFT JOIN {{ ref('dim_date') }} clod 
     ON clod.date = brg.closure_date -- Adjust if separate closure date exists
 LEFT JOIN {{ ref('dim_date') }} shid
     ON shid.date = brg.shipping_date -- Adjust if shipping date exists

-- SCD2 Dimensions
LEFT JOIN {{ ref('dim_company') }} com 
    ON UPPER(com.bkey_company) = UPPER(brg.bkey_company)
    AND (com.valid_from <= dat.date OR com.valid_from IS NULL)
    AND (com.valid_to > dat.date OR com.valid_to IS NULL)

LEFT JOIN {{ ref('dim_customer') }} cus 
    ON cus.bkey_customer = brg.bkey_customer
    AND (cus.valid_from <= dat.date OR cus.valid_from IS NULL)
    AND (cus.valid_to > dat.date OR cus.valid_to IS NULL)

-- SCD1 Dimensions
LEFT JOIN {{ ref('dim_currency') }} cur 
    ON cur.bkey_currency = brg.bkey_currency
LEFT JOIN {{ ref('dim_country') }} cou 
    ON cou.bkey_country = brg.bkey_country
LEFT JOIN {{ ref('dim_product') }} prod 
    ON prod.bkey_product = brg.bkey_product
LEFT JOIN {{ ref('dim_product_global') }} prog
    ON prog.bkey_product_global = brg.bkey_product_global
LEFT JOIN {{ ref('dim_payment_term') }} pay 
    ON pay.bkey_payment_term = brg.bkey_payment_term
LEFT JOIN {{ ref('dim_business_unit') }} bu 
    ON bu.bkey_business_unit = brg.bkey_business_unit
LEFT JOIN {{ ref('dim_customer_industry_invoice') }} ci 
    ON ci.bkey_customer_industry_invoice = brg.bkey_customer_industry_invoice
LEFT JOIN {{ ref('dim_cost_center') }} cc 
    ON cc.bkey_cost_center = brg.bkey_cost_center
LEFT JOIN {{ ref('dim_cost_center') }} pc 
    ON pc.bkey_cost_center = brg.bkey_profit_center
LEFT JOIN {{ ref('dim_site') }} src_ds 
    ON src_ds.bkey_site = brg.bkey_site


LEFT JOIN {{ ref('bv_currency_rate') }} hgc 
    ON hgc.currency_rate_consolidation_code = 
            CASE 
                WHEN clod.month_key < '202501' THEN CONCAT(clod.month_key, 'ACT000') -- IFR100 is leading period from 202501 onwards
                ELSE CONCAT(clod.month_key, 'IFR100')
            END
        AND hgc.currency_rate_currency_code = com.company_home_currency
LEFT JOIN {{ ref('bv_currency_rate') }} lgc 
    ON lgc.currency_rate_consolidation_code = 
            CASE 
                WHEN clod.month_key < '202501' THEN CONCAT(clod.month_key, 'ACT000') -- IFR100 is leading period from 202501 onwards
                ELSE CONCAT(clod.month_key, 'IFR100')
            END
        AND lgc.currency_rate_currency_code = brg.bkey_currency

    -- Filter
    WHERE dat.year BETWEEN '2020' AND YEAR(GETDATE())

-- Grouping
GROUP BY 
    dat.tkey_date,
    clod.tkey_date,
    shid.tkey_date,
    com.tkey_company,
    cur.tkey_currency,
    cou.tkey_country,
    cus.tkey_customer,
    prod.tkey_product,
    prog.tkey_product_global,
    pay.tkey_payment_term,
    cc.tkey_cost_center,
    pc.tkey_cost_center,
    ci.tkey_customer_industry_invoice,
    bu.tkey_business_unit,
    src_ds.tkey_site,
    brg.invoice_number,
    brg.invoice_line_number,
    --brg.closure_date,
    brg.credit_note_id,
    brg.uom_original,
    brg.order_value,
    brg.actual_budget,
    brg.bkey_source,
    brg.version
