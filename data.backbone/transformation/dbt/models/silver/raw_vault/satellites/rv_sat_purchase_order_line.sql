WITH purchase_order_line AS (
    SELECT
        bkey_purchase_order_line_source,
        bkey_source,
        purchase_order_line_purchase_id,
        purchase_order_line_line_number,
        purchase_order_line_company,
        purchase_order_line_name,
        purchase_order_line_delivery_term,
        purchase_order_line_quantity_ordered,
        purchase_order_line_purchase_unit,
        purchase_order_line_amount_trans_cur,
        purchase_order_line_amount_func_cur,
        purchase_order_line_amount_group_cur_oanda_spot,
        purchase_order_line_group_cur_oanda_rate,
        purchase_order_line_func_cur_rate,
        purchase_order_line_transactional_currency_code,
        purchase_order_line_group_currency_code,
        purchase_order_line_functional_currency_code,
        purchase_order_line_price_unit,
        purchase_order_line_delivery_mode,
        purchase_order_line_created_date_time,
        purchase_order_line_purchase_status,
        purchase_order_line_inventory_dimension_id,
        purchase_order_line_partition,
        purchase_order_line_lgs_logistic_file_id,
        purchase_order_line_product_id,
        purchase_order_line_purchase_price,
        purchase_order_line_vendor_account,
        purchase_order_line_purchase_quantity,
        purchase_order_line_purchase_quantity_mt,
        purchase_order_line_uom,
        valid_from,
        valid_to,
        is_current
    FROM {{ ref('purchase_order_line_dynamics')}}
)

SELECT
    *
FROM purchase_order_line