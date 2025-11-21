-- Auto Generated (Do not modify) FF4FD95D0E09C642009640A2E7279C638F808C804A0E441285D3D12F02F23C01
create view "mim"."bv_sales_invoice" as WITH source_sales_invoice AS (
    SELECT
        hub.bkey_sales_invoice_source,
        hub.bkey_sales_invoice,
        sat.bkey_source,
        sat.sales_invoice_id,
        sat.sales_invoice_customer_id,
        sat.sales_invoice_order_customer_id,
        sat.sales_invoice_company,
        sat.sales_invoice_transactional_currency_code,
        sat.sales_invoice_group_currency_code,
        sat.sales_invoice_functional_currency_code,
        sat.sales_invoice_date,
        sat.sales_invoice_document_date,
        sat.sales_invoice_due_date,
        sat.sales_invoice_closure_date,
        sat.sales_invoice_shipping_date,

        -- Invoice Amounts
        sat.sales_invoice_amount_trans_cur,
        sat.sales_invoice_amount_func_cur,
        sat.sales_invoice_amount_group_cur_conso_eom,
        sat.sales_invoice_amount_group_cur_conso_avg,
        sat.sales_invoice_amount_group_cur_oanda_eod,
        -- Open Amounts
        sat.sales_invoice_open_amount_trans_cur,
        sat.sales_invoice_open_amount_func_cur,
        sat.sales_invoice_open_amount_group_cur_conso_eom,
        sat.sales_invoice_open_amount_group_cur_conso_avg,
        sat.sales_invoice_open_amount_group_cur_oanda_eod,
        -- Settled Amounts
        sat.sales_invoice_settled_amount_trans_cur,
        sat.sales_invoice_settled_amount_func_cur,
        sat.sales_invoice_settled_amount_group_cur_conso_eom,
        sat.sales_invoice_settled_amount_group_cur_conso_avg,
        sat.sales_invoice_settled_amount_group_cur_oanda_eod,
        -- Currency Rates
        sat.sales_invoice_group_cur_conso_eom_rate,
        sat.sales_invoice_group_cur_conso_avg_rate,
        sat.sales_invoice_func_cur_rate,

        sat.sales_invoice_name,
        sat.sales_invoice_customer_vat,
        sat.sales_invoice_destination_country,
        sat.sales_invoice_external_reference,
        sat.sales_invoice_payment_schedule,
        sat.sales_invoice_ledger_voucher,
        sat.sales_invoice_order_value,
        sat.sales_invoice_payment,
        sat.sales_invoice_txt,
        sat.sales_invoice_closed,
        sat.sales_invoice_payment_reference,
        sat.sales_invoice_paymtermid,
        sat.sales_invoice_procenvalue,
        sat.sales_invoice_coscenvalue,
        sat.sales_invoice_logistic_id,
        sat.sales_invoice_ledger_account,
        sat.sales_invoice_industry_code,
        sat.sales_invoice_invent_location,
        sat.sales_invoice_site_id,
        sat.valid_from,
        sat.valid_to,
        sat.is_current
    FROM "dbb_warehouse"."mim"."rv_hub_sales_invoice" hub
    LEFT JOIN "dbb_warehouse"."mim"."rv_sat_sales_invoice" sat 
        ON hub.bkey_sales_invoice_source = sat.bkey_sales_invoice_source
    -- WHERE hub.bkey_source = 'DYNAMICS'
)

SELECT
    *
FROM source_sales_invoice;;