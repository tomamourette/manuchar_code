WITH source_sales_invoice_line AS (
    SELECT
        hub.bkey_sales_invoice_line,
        hub.bkey_sales_invoice_line_source,
        sat.bkey_sales_invoice,
        sat.bkey_source,
        sales_invoice_id,
        sales_invoice_line_invoice_line_num,
        sales_invoice_line_product_id,
        sales_invoice_line_product_name,
        sales_invoice_line_quantity,
        sales_invoice_line_quantity_mt,
        sales_invoice_line_uom,
        
        sales_invoice_line_amount_trans_cur,
        sales_invoice_line_amount_func_cur,
        sales_invoice_line_amount_group_cur_conso_avg,
        sales_invoice_line_amount_group_cur_oanda_eod,

        sales_invoice_line_group_cur_conso_avg_rate,
        sales_invoice_line_func_cur_rate,

        sales_invoice_line_company,
        sales_invoice_line_transactional_currency_code,
        sales_invoice_line_group_currency_code,
        sales_invoice_line_functional_currency_code,
        sales_invoice_line_ledger_voucher,
	    sales_invoice_line_business_unit,
        sales_invoice_line_product_global_code,
        valid_from,
        valid_to,
        is_current
    FROM {{ ref('rv_hub_sales_invoice_line')}} hub
    LEFT JOIN {{ ref('rv_sat_sales_invoice_line')}} sat ON hub.bkey_sales_invoice_line_source = sat.bkey_sales_invoice_line_source
    --WHERE hub.bkey_source = 'DYNAMICS'
)

SELECT
    *
FROM source_sales_invoice_line