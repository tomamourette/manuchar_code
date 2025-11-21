WITH purchase_invoice AS (
    SELECT 
        bkey_purchase_invoice_source,
        bkey_source,
        purchase_invoice_id,
        purchase_invoice_supplier_id,
        purchase_invoice_order_supplier_id,
        purchase_invoice_company,
        purchase_invoice_closure_date,
        purchase_invoice_transactional_currency_code,
        purchase_invoice_group_currency_code,
        purchase_invoice_functional_currency_code,
        purchase_invoice_date,
        purchase_invoice_document_date,
        purchase_invoice_due_date,

        purchase_invoice_amount_trans_cur,
        purchase_invoice_amount_func_cur,   
        purchase_invoice_amount_group_cur_conso_eom,
        purchase_invoice_amount_group_cur_conso_avg,
        purchase_invoice_amount_group_cur_oanda_eod,

        purchase_invoice_open_amount_trans_cur,
        purchase_invoice_open_amount_func_cur,
        purchase_invoice_open_amount_group_cur_conso_eom,
        purchase_invoice_open_amount_group_cur_conso_avg,
        purchase_invoice_open_amount_group_cur_oanda_eod,

        purchase_invoice_settled_amount_trans_cur,
        purchase_invoice_settled_amount_func_cur,
        purchase_invoice_settled_amount_group_cur_conso_eom,
        purchase_invoice_settled_amount_group_cur_conso_avg,
        purchase_invoice_settled_amount_group_cur_oanda_eod,

        purchase_invoice_group_cur_conso_eom_rate,
        purchase_invoice_group_cur_conso_avg_rate,
        purchase_invoice_func_cur_rate,

        purchase_invoice_ledger_voucher,
        purchase_invoice_legal_number,
        purchase_invoice_payment,
        purchase_invoice_payment_schedule,
        purchase_invoice_logistic_file_id,
        purchase_invoice_tax_amount,
        purchase_invoice_purchase_id,
        purchase_invoice_reporting_currency_exchange_rate,
        purchase_invoice_exchange_rate,
        purchase_invoice_quantity,
        purchase_invoice_internal_invoice_id,
        purchase_invoice_account_number,
        purchase_invoice_file_number,
        purchase_invoice_industry_code,
        purchase_invoice_closed,
        valid_from,
        valid_to,
        is_current
    FROM {{ ref('purchase_invoice_dynamics')}}
)

SELECT
    *
FROM purchase_invoice