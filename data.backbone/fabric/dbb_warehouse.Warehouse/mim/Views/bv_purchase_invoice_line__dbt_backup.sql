-- Auto Generated (Do not modify) 9814511BBC9A9F46B652F0AE16A0F4DDAA49DC4DE22F554C37CB02236C3EB959
create view "mim"."bv_purchase_invoice_line" as WITH purchase_invoice_line AS (
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

        sat.purchase_invoice_line_closing_rate,
        sat.purchase_invoice_line_average_month_rate,

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
    FROM "dbb_warehouse"."mim"."rv_hub_purchase_invoice_line" hub
    LEFT JOIN "dbb_warehouse"."mim"."rv_sat_purchase_invoice_line" sat ON hub.bkey_purchase_invoice_line_source = sat.bkey_purchase_invoice_line_source
    WHERE hub.bkey_source = 'DYNAMICS'
)

SELECT
    *
FROM purchase_invoice_line;