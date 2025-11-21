WITH purchase_invoice AS (
    SELECT 
        hub.bkey_purchase_invoice,
        hub.bkey_source,
        sat.purchase_invoice_id,
        sat.purchase_invoice_supplier_id,
        sat.purchase_invoice_order_supplier_id,
        sat.purchase_invoice_company,
        sat.purchase_invoice_closure_date,
        sat.purchase_invoice_transactional_currency_code,
        sat.purchase_invoice_group_currency_code,
        sat.purchase_invoice_functional_currency_code,
        sat.purchase_invoice_date,
        sat.purchase_invoice_document_date,
        sat.purchase_invoice_due_date,
        
        sat.purchase_invoice_amount_trans_cur,
        sat.purchase_invoice_amount_func_cur,   
        sat.purchase_invoice_amount_group_cur_conso_eom,
        sat.purchase_invoice_amount_group_cur_conso_avg,
        sat.purchase_invoice_amount_group_cur_oanda_eod,

        sat.purchase_invoice_open_amount_trans_cur,
        sat.purchase_invoice_open_amount_func_cur,
        sat.purchase_invoice_open_amount_group_cur_conso_eom,
        sat.purchase_invoice_open_amount_group_cur_conso_avg,
        sat.purchase_invoice_open_amount_group_cur_oanda_eod,

        sat.purchase_invoice_settled_amount_trans_cur,
        sat.purchase_invoice_settled_amount_func_cur,
        sat.purchase_invoice_settled_amount_group_cur_conso_eom,
        sat.purchase_invoice_settled_amount_group_cur_conso_avg,
        sat.purchase_invoice_settled_amount_group_cur_oanda_eod,

        sat.purchase_invoice_group_cur_conso_eom_rate,
        sat.purchase_invoice_group_cur_conso_avg_rate,
        sat.purchase_invoice_func_cur_rate,
    
        sat.purchase_invoice_ledger_voucher,
        sat.purchase_invoice_legal_number,
        sat.purchase_invoice_payment,
        sat.purchase_invoice_payment_schedule,
        sat.purchase_invoice_logistic_file_id,
        sat.purchase_invoice_tax_amount,
        sat.purchase_invoice_purchase_id,
        sat.purchase_invoice_reporting_currency_exchange_rate,
        sat.purchase_invoice_exchange_rate,
        sat.purchase_invoice_quantity,
        sat.purchase_invoice_internal_invoice_id,
        sat.purchase_invoice_account_number,
        sat.purchase_invoice_file_number,
        sat.purchase_invoice_industry_code,
        sat.purchase_invoice_closed,
        sat.valid_from,
        sat.valid_to,
        sat.is_current
    FROM {{ ref('rv_hub_purchase_invoice')}} hub
    LEFT JOIN {{ ref('rv_sat_purchase_invoice')}} sat ON hub.bkey_purchase_invoice_source = sat.bkey_purchase_invoice_source
    WHERE hub.bkey_source = 'DYNAMICS'
)

SELECT
    *
FROM purchase_invoice