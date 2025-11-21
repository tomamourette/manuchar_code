WITH purchase_invoice_line AS (
    SELECT
        bkey_purchase_invoice_line_source,
        bkey_purchase_invoice,
        bkey_source,
        purchase_invoice_line_number,
        purchase_invoice_line_description,
        purchase_invoice_line_quantity,
        purchase_invoice_line_product_id,
        
        purchase_invoice_line_amount_trans_cur,
        purchase_invoice_line_amount_func_cur,
        purchase_invoice_line_amount_group_cur_conso_avg,
        purchase_invoice_line_amount_group_cur_oanda_eod,

        purchase_invoice_line_group_cur_oanda_eod_rate,
        purchase_invoice_line_group_cur_conso_avg_rate,
        purchase_invoice_line_func_cur_rate,

        purchase_invoice_line_transactional_currency_code,
        purchase_invoice_line_group_currency_code,
        purchase_invoice_line_functional_currency_code,
        purchase_invoice_line_company,
        purchase_invoice_line_UOM,
        purchase_invoice_line_ledger_voucher,
        purchase_invoice_line_payment_term_id,
        purchase_invoice_line_closed,
        purchase_invoice_line_tax_amount,
        valid_from,
        valid_to,
        is_current
    FROM {{ ref('purchase_invoice_line_dynamics')}}
)

SELECT
    *
FROM purchase_invoice_line