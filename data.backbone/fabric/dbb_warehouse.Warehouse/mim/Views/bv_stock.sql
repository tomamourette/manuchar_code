-- Auto Generated (Do not modify) 09512F770AFEC6E6E3B58C54D8DC6211DA20D2F4A784A6144D2F3139EB08432C
create view "mim"."bv_stock" as WITH source_stock AS (
    SELECT
        hub.bkey_stock,
        hub.bkey_source,
        stock_company,
        stock_customer_id,
        stock_currency,
        stock_closure_date,
        stock_entry_date,
        stock_warehouse_name,
        stock_invent_location_id,
        stock_site_id,
        stock_lot_number,
        stock_product_code,
        stock_product_id,
        stock_quantity,
        stock_quantity_mt,
        stock_uom,
        stock_amount_func_cur,
        stock_amount_group_conso_eom,
        stock_amount_group_oanda_eod,
        stock_committed,
        stock_in_transit,
        valid_from,
        valid_to,
        is_current
    FROM "dbb_warehouse"."mim"."rv_hub_stock" hub
    LEFT JOIN "dbb_warehouse"."mim"."rv_sat_stock" sat ON hub.bkey_stock_source = sat.bkey_stock_source
    -- WHERE is_current = 1 -- add only the latest version
)

SELECT
    *
FROM source_stock;;