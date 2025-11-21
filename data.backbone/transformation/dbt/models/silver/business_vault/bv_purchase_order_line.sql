WITH purchase_order_line AS (
    SELECT
        hub.bkey_purchase_order_line,
        sat.purchase_order_line_purchase_id,
        sat.purchase_order_line_line_number,
        sat.purchase_order_line_company,
        sat.purchase_order_line_name,
        sat.purchase_order_line_delivery_term,
        sat.purchase_order_line_quantity_ordered,
        sat.purchase_order_line_purchase_unit,
        sat.purchase_order_line_amount_trans_cur,
        sat.purchase_order_line_amount_func_cur,
        sat.purchase_order_line_amount_group_cur_oanda_spot,
        sat.purchase_order_line_group_cur_oanda_rate,
        sat.purchase_order_line_func_cur_rate,
        sat.purchase_order_line_transactional_currency_code,
        sat.purchase_order_line_group_currency_code,
        sat.purchase_order_line_functional_currency_code,
        sat.purchase_order_line_price_unit,
        sat.purchase_order_line_delivery_mode,
        sat.purchase_order_line_created_date_time,
        sat.purchase_order_line_purchase_status,
        sat.purchase_order_line_inventory_dimension_id,
        sat.purchase_order_line_partition,
        sat.purchase_order_line_lgs_logistic_file_id,
        sat.purchase_order_line_product_id,
        sat.purchase_order_line_purchase_price,
        sat.purchase_order_line_vendor_account,
        sat.purchase_order_line_purchase_quantity,
        sat.purchase_order_line_purchase_quantity_mt,
        sat.purchase_order_line_uom,
        sat.valid_from,
        sat.valid_to,
        sat.is_current
    FROM {{ ref('rv_hub_purchase_order_line')}} hub
    LEFT JOIN {{ ref('rv_sat_purchase_order_line')}} sat ON hub.bkey_purchase_order_line_source = sat.bkey_purchase_order_line_source
    WHERE hub.bkey_source = 'DYNAMICS'
)

SELECT
    *
FROM purchase_order_line