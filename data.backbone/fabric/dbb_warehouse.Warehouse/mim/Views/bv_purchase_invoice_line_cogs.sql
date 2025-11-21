-- Auto Generated (Do not modify) 00AED12FB007CBCB4B2EC0502C90F32EB5FEECFB2A6C735B99506E69ABEE22BA
create view "mim"."bv_purchase_invoice_line_cogs" as WITH purchase_invoice_line_cogs AS (
    SELECT
	    sat.tkey_purchase_invoice_line_cogs,
        hub.bkey_purchase_invoice_line_cogs,
        hub.bkey_source,
        sat.bkey_flow,
        sat.purchase_invoice_line_cogs_file_number,
        sat.purchase_invoice_line_cogs_payment_schedule,
        sat.purchase_invoice_line_cogs_payment,
        sat.purchase_invoice_line_cogs_dct_destination,
        sat.purchase_invoice_line_cogs_ecs_contract_status,
        sat.purchase_invoice_line_cogs_risk_trading_book_id,
        sat.purchase_invoice_line_cogs_created_date_time,
        sat.purchase_invoice_line_cogs_company,
        sat.purchase_invoice_line_cogs_order_account,
        sat.purchase_invoice_line_cogs_requester,
        sat.purchase_invoice_line_cogs_risk_trader,
        sat.purchase_invoice_line_cogs_worker_purchase_placer,
        sat.purchase_invoice_line_cogs_purchase_state,
        sat.purchase_invoice_line_cogs_ccs_closing_status,
        sat.purchase_invoice_line_cogs_ecs_trade_type,
        sat.purchase_invoice_line_cogs_purchase_type,
        sat.purchase_invoice_line_cogs_invoice_account,
        sat.purchase_invoice_line_cogs_accounting_date,
        sat.purchase_invoice_line_cogs_internal_invoice_id,
        sat.purchase_invoice_line_cogs_product,
        sat.purchase_invoice_line_cogs_purchase_id,
        sat.purchase_invoice_line_cogs_line_number,
        sat.purchase_invoice_line_cogs_incoterm,
        sat.purchase_invoice_line_cogs_origin_country,
        sat.purchase_invoice_line_cogs_destination_country,
        sat.purchase_invoice_line_cogs_adjusted_cogs_functional,
        sat.purchase_invoice_line_cogs_adjusted_cogs_transactional,
        sat.purchase_invoice_line_cogs_adjusted_cogs_group_conso_avg,
        sat.purchase_invoice_line_cogs_cogs1_purchase_amount_functional,
        sat.purchase_invoice_line_cogs_cogs1_purchase_amount_transactional,
        sat.purchase_invoice_line_cogs_cogs1_purchase_amount_group_conso_avg,
        sat.purchase_invoice_line_cogs_cogs1_freight_amount_functional,
        sat.purchase_invoice_line_cogs_cogs1_freight_amount_transactional,
        sat.purchase_invoice_line_cogs_cogs1_freight_amount_group_conso_avg,
        sat.purchase_invoice_line_cogs_cogs1_other_amount_functional,
        sat.purchase_invoice_line_cogs_cogs1_other_amount_transactional,
        sat.purchase_invoice_line_cogs_cogs1_other_amount_group_conso_avg,
        sat.valid_from,
        sat.valid_to,
        sat.is_current
    FROM "dbb_warehouse"."mim"."rv_hub_purchase_invoice_line_cogs" hub
    LEFT JOIN "dbb_warehouse"."mim"."rv_sat_purchase_invoice_line_cogs" sat
        ON hub.bkey_purchase_invoice_line_cogs_source = sat.bkey_purchase_invoice_line_cogs_source
    WHERE hub.bkey_source = 'DYNAMICS'
)

SELECT
    *
FROM purchase_invoice_line_cogs;