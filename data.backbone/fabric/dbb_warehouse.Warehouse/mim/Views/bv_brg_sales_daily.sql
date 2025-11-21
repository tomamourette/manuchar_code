-- Auto Generated (Do not modify) BAE968008FEF86B8063A79430EC2526A82D706F5385F7715D5D4FAE21ACEFBE4
create view "mim"."bv_brg_sales_daily" as SELECT 
    -- Date Keys
    CASE WHEN inv.sales_invoice_id LIKE '[0-9]%' THEN CAST(inv.sales_invoice_document_date AS DATE) ELSE CAST(inv.sales_invoice_date AS DATE) END AS invoice_date,
    inv.sales_invoice_closure_date AS closure_date,
    inv.sales_invoice_shipping_date AS shipping_date,

    -- Dimension Keys
    inv.sales_invoice_company AS bkey_company,
    CONCAT(UPPER(inv.sales_invoice_company), '_', inv.sales_invoice_customer_id) AS bkey_customer,
    inv.sales_invoice_industry_code AS bkey_customer_industry_invoice,
    CONCAT('BU ', invl.sales_invoice_line_business_unit) AS bkey_business_unit,
    inv.sales_invoice_paymtermid AS bkey_payment_term,
    inv.sales_invoice_destination_country AS bkey_destination_country,
    inv.sales_invoice_site_id AS bkey_site,
    inv.sales_invoice_local_currency_code AS bkey_currency,
    invl.sales_invoice_line_product_id AS bkey_product,
    invl.sales_invoice_line_product_global_code AS bkey_product_global,
    
    -- Numerical Fields
    
    -- Invoice Line Amounts
    invl.sales_invoice_line_amount_trans_cur,
    invl.sales_invoice_line_amount_func_cur,
    invl.sales_invoice_line_amount_group_cur_oanda_eod,
   
    -- Volume Amounts
    COALESCE(invl.sales_invoice_line_quantity, 0) AS invoice_volume_original,
    COALESCE(invl.sales_invoice_line_quantity_mt, 0) AS invoice_volume_mt,

    -- Fact Fields
    inv.sales_invoice_order_value AS order_value,
    invl.sales_invoice_line_uom AS sales_uom_original,
    inv.sales_invoice_id AS invoice_number,
    invl.sales_invoice_line_number AS invoice_line_number,
    CASE
        WHEN LEFT(RIGHT(inv.sales_invoice_id, 11), 3) IN ('ICN', 'SPC') THEN inv.sales_invoice_id
        WHEN LEFT(RIGHT(inv.sales_invoice_id, 10), 2) = 'CN' THEN inv.sales_invoice_id
        ELSE NULL
    END AS credit_note_id

FROM "dbb_warehouse"."mim"."bv_sales_invoice" inv
LEFT JOIN "dbb_warehouse"."mim"."bv_sales_invoice_line" invl
    ON inv.bkey_sales_invoice = invl.bkey_sales_invoice
WHERE inv.bkey_source = 'DYNAMICS' 
AND inv.is_current = 1;