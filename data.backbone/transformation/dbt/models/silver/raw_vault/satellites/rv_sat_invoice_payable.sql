WITH invoice_payable AS (
    SELECT
        bkey_invoice_payable_source,
        bkey_source,
        invoice_payable_invoice_id,
        invoice_payable_supplier_id,
        invoice_payable_company,
        invoice_payable_local_currency_code,
        CONVERT(DATETIME2(6), CONVERT(VARCHAR, invoice_payable_invoice_date), 103) AS invoice_payable_invoice_date,
        CONVERT(DATETIME2(6), CONVERT(VARCHAR, invoice_payable_due_date), 103) AS invoice_payable_due_date,
        CONVERT(DATETIME2(6), CONVERT(VARCHAR, invoice_payable_closure_date), 103) AS invoice_payable_closure_date,
        
        invoice_payable_amount_trans_cur,
        invoice_payable_amount_func_cur,
        invoice_payable_amount_group_cur_conso_eom,
        invoice_payable_amount_group_cur_conso_avg,
        invoice_payable_amount_group_cur_oanda_eod,

        invoice_payable_open_amount_trans_cur,
        invoice_payable_open_amount_func_cur,
        invoice_payable_open_amount_group_cur_conso_eom,
        invoice_payable_open_amount_group_cur_conso_avg,
        invoice_payable_open_amount_group_cur_oanda_eod,

        invoice_payable_settled_amount_trans_cur,
        invoice_payable_settled_amount_func_cur,
        invoice_payable_settled_amount_group_cur_conso_eom,
        invoice_payable_settled_amount_group_cur_conso_avg,
        invoice_payable_settled_amount_group_cur_oanda_eod,
        
        invoice_payable_payment_schedule,
        invoice_payable_file_name,
        valid_from,
        valid_to,
        is_current
    FROM {{ ref('invoice_payable_stg')}}
)

SELECT
    *
FROM invoice_payable