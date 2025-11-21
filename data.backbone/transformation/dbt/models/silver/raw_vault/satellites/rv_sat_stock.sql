WITH stock_stg AS (
    SELECT
        CAST(bkey_stock_source AS VARCHAR(255)) AS bkey_stock_source,
        CAST(stock_company AS VARCHAR(50)) AS stock_company,
        CAST(stock_customer_id AS VARCHAR(50)) AS stock_customer_id,
        CAST(stock_currency AS VARCHAR(50)) AS stock_currency,
        CONVERT(DATETIME2(6), CONVERT(VARCHAR, stock_closure_date), 103) AS stock_closure_date,
        CONVERT(DATETIME2(6), CONVERT(VARCHAR, stock_entry_date), 103) AS stock_entry_date,
        CAST(stock_warehouse_name AS VARCHAR(255)) AS stock_warehouse_name,
        CAST(stock_invent_location_id AS VARCHAR(255)) AS stock_invent_location_id,
        CAST(stock_site_id AS VARCHAR(255)) AS stock_site_id,
        CAST(stock_lot_number AS VARCHAR(255)) AS stock_lot_number,
        CAST(stock_product_code AS VARCHAR(255)) AS stock_product_code,
        CAST(stock_product_id AS VARCHAR(255)) AS stock_product_id,
        CAST(stock_quantity AS DECIMAL(18, 4)) AS stock_quantity,
        CAST(stock_quantity_mt AS DECIMAL(18, 4)) AS stock_quantity_mt,
        CAST(stock_uom AS VARCHAR(50)) AS stock_uom,
        CAST(stock_amount_func_cur AS DECIMAL(18, 4)) AS stock_amount_func_cur,
        CAST(stock_amount_group_conso_eom AS DECIMAL(18, 4)) AS stock_amount_group_conso_eom,
        CAST(stock_amount_group_oanda_eod AS DECIMAL(18, 4)) AS stock_amount_group_oanda_eod,
        CAST(stock_committed AS BIT) AS stock_committed,
        CAST(stock_in_transit AS BIT) AS stock_in_transit,
        valid_from,
        valid_to,
        is_current
    FROM {{ ref('stock_stg') }}
),

stock_dynamics AS (
    SELECT
        CAST(bkey_stock_source AS VARCHAR(255)) AS bkey_stock_source,
        CAST(stock_company AS VARCHAR(50)) AS stock_company,
        CAST(stock_customer_id AS VARCHAR(50)) AS stock_customer_id,
        CAST(stock_currency AS VARCHAR(50)) AS stock_currency,
        CAST(stock_closure_date AS DATETIME2(6)) AS stock_closure_date,
        CAST(stock_entry_date AS DATETIME2(6)) AS stock_entry_date,
        CAST(stock_warehouse_name AS VARCHAR(255)) AS stock_warehouse_name,
        CAST(stock_invent_location_id AS VARCHAR(255)) AS stock_invent_location_id,
        CAST(stock_site_id AS VARCHAR(255)) AS stock_site_id,
        CAST(stock_lot_number AS VARCHAR(255)) AS stock_lot_number,
        CAST(stock_product_code AS VARCHAR(255)) AS stock_product_code,
        CAST(stock_product_id AS VARCHAR(255)) AS stock_product_id,
        CAST(stock_quantity AS DECIMAL(18, 4)) AS stock_quantity,
        CAST(stock_quantity_mt AS DECIMAL(18, 4)) AS stock_quantity_mt,
        CAST(stock_uom AS VARCHAR(50)) AS stock_uom,
        CAST(stock_amount_func_cur AS DECIMAL(18, 4)) AS stock_amount_func_cur,
        CAST(stock_amount_group_conso_eom AS DECIMAL(18, 4)) AS stock_amount_group_conso_eom,
        CAST(stock_amount_group_oanda_eod AS DECIMAL(18, 4)) AS stock_amount_group_oanda_eod,
        CAST(stock_committed AS BIT) AS stock_committed,
        CAST(stock_in_transit AS BIT) AS stock_in_transit,
        valid_from,
        valid_to,
        is_current
    FROM {{ ref('stock_dynamics') }}
)

SELECT * FROM stock_stg
UNION ALL
SELECT * FROM stock_dynamics