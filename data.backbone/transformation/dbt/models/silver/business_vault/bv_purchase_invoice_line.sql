WITH purchase_invoice_line AS (
    SELECT
        hub.bkey_purchase_invoice_line,
        sat.bkey_purchase_invoice,
        sat.purchase_invoice_line_number,
        sat.purchase_invoice_line_description,
        sat.purchase_invoice_line_quantity,
        sat.purchase_invoice_line_product_id,
        
        sat.purchase_invoice_line_amount_trans_cur,
        sat.purchase_invoice_line_amount_func_cur,
        sat.purchase_invoice_line_amount_group_cur_conso_avg,
        sat.purchase_invoice_line_amount_group_cur_oanda_eod,

        sat.purchase_invoice_line_group_cur_oanda_eod_rate,
        sat.purchase_invoice_line_group_cur_conso_avg_rate,
        sat.purchase_invoice_line_func_cur_rate,

        sat.purchase_invoice_line_transactional_currency_code,
        sat.purchase_invoice_line_group_currency_code,
        sat.purchase_invoice_line_functional_currency_code,
        sat.purchase_invoice_line_company,
        sat.purchase_invoice_line_UOM,
        sat.purchase_invoice_line_ledger_voucher,
        sat.purchase_invoice_line_payment_term_id,
        sat.purchase_invoice_line_closed,
        sat.purchase_invoice_line_tax_amount,
        sat.valid_from,
        sat.valid_to,
        sat.is_current
    FROM {{ ref('rv_hub_purchase_invoice_line')}} hub
    LEFT JOIN {{ ref('rv_sat_purchase_invoice_line')}} sat ON hub.bkey_purchase_invoice_line_source = sat.bkey_purchase_invoice_line_source
    WHERE hub.bkey_source = 'DYNAMICS'
)

SELECT
    *
FROM purchase_invoice_line