-- Auto Generated (Do not modify) 8E6EAA79E89183F3E5E0A98ED51110A6745F035FF4672B12675E3A38749D1C45
create view "mim"."bv_invoice_payable" as WITH invoice_payable AS (
    SELECT
        hub.bkey_invoice_payable,
        hub.bkey_source,
        sat.invoice_payable_invoice_id,
        sat.invoice_payable_supplier_id,
        sat.invoice_payable_company,
        sat.invoice_payable_local_currency_code,
        sat.invoice_payable_invoice_date,
        sat.invoice_payable_due_date,
        sat.invoice_payable_closure_date,
        
        sat.invoice_payable_amount_trans_cur,
        sat.invoice_payable_amount_func_cur,
        sat.invoice_payable_amount_group_cur_conso_eom,
        sat.invoice_payable_amount_group_cur_conso_avg,
        sat.invoice_payable_amount_group_cur_oanda_eod,

        sat.invoice_payable_open_amount_trans_cur,
        sat.invoice_payable_open_amount_func_cur,
        sat.invoice_payable_open_amount_group_cur_conso_eom,
        sat.invoice_payable_open_amount_group_cur_conso_avg,
        sat.invoice_payable_open_amount_group_cur_oanda_eod,

        sat.invoice_payable_settled_amount_trans_cur,
        sat.invoice_payable_settled_amount_func_cur,
        sat.invoice_payable_settled_amount_group_cur_conso_eom,
        sat.invoice_payable_settled_amount_group_cur_conso_avg,
        sat.invoice_payable_settled_amount_group_cur_oanda_eod,

        sat.invoice_payable_payment_schedule,
        sat.invoice_payable_file_name,
        sat.valid_from,
        sat.valid_to,
        sat.is_current
    FROM "dbb_warehouse"."mim"."rv_hub_invoice_payable" hub
    LEFT JOIN "dbb_warehouse"."mim"."rv_sat_invoice_payable" sat ON hub.bkey_invoice_payable_source = sat.bkey_invoice_payable_source
    WHERE hub.bkey_source = 'STG_AP'
)

SELECT
    *
FROM invoice_payable;