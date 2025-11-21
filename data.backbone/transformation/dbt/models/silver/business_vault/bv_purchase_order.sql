WITH purchase_order AS (
    SELECT
        hub.bkey_purchase_order,
        hub.bkey_source,
        sat.purchase_order_payment_schedule,
        sat.purchase_order_payment,
        sat.purchase_order_dct_destination,
        sat.purchase_order_ecs_contract_status,
        sat.purchase_order_risk_trading_book_id,
        sat.purchase_order_created_date_time,
        sat.purchase_order_company,
        sat.purchase_order_partition,
        sat.purchase_order_order_account,
        sat.purchase_order_requester,
        sat.purchase_order_risk_trader,
        sat.purchase_order_worker_purchase_placer,
        sat.purchase_order_purchase_state,
        sat.purchase_order_ccs_closing_status,
        sat.purchase_order_ecs_trade_type,
        sat.purchase_order_purchase_type,
        sat.purchase_order_invoice_account,
        sat.purchase_order_accounting_date,
        sat.purchase_order_invoice_date,
        sat.purchase_order_amount_trans_cur,
        sat.purchase_order_amount_func_cur,
        sat.purchase_order_amount_group_cur_oanda_eod,
        sat.purchase_order_group_cur_oanda_eod_rate,
        sat.purchase_order_func_cur_rate,
        sat.purchase_order_internal_invoice_id,
        sat.purchase_order_local_product,
        sat.purchase_order_product,
        sat.purchase_order_transactional_currency_code,
        sat.purchase_order_group_currency_code,
        sat.purchase_order_functional_currency_code,
        sat.purchase_order_line_number,
        sat.purchase_order_incoterm,
        sat.purchase_order_origin_country,
        sat.purchase_order_destination_country,
        sat.purchase_order_quantity,
        sat.purchase_order_quantity_mt,
        sat.purchase_order_uom,
        sat.valid_from,
        sat.valid_to,
        sat.is_current
    FROM {{ ref('rv_hub_purchase_order')}} hub
    LEFT JOIN {{ ref('rv_sat_purchase_order')}} sat ON hub.bkey_purchase_order_source = sat.bkey_purchase_order_source
    WHERE hub.bkey_source = 'DYNAMICS'
)

SELECT
    *
FROM purchase_order