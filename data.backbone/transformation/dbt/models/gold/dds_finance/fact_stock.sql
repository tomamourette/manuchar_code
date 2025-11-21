SELECT 
    -- Date Keys
    entd.tkey_date AS tkey_entry_date,
    snad.tkey_date AS tkey_snapshot_date,
    -- Dimension Tkeys
    com.tkey_company,
    cus.tkey_customer,
    cur.tkey_currency,
    sag.tkey_stock_age_group,
    pro.tkey_product,
    prog.tkey_product_global,
    sit.tkey_site,
    CAST(brg.stock_committed AS BIT) AS stock_committed,
    CAST(brg.stock_in_transit AS BIT) AS stock_in_transit,
    -- Fact Numeric Values
    CAST(brg.stock_quantity AS DECIMAL(18, 4)) AS stock_quantity,
    CAST(brg.stock_quantity_mt AS DECIMAL(18, 4)) AS stock_quantity_mt,
    -- Stock Amounts
    stock_amount_functional_currency​,
    stock_amount_group_conso_EOM_currency​,
    stock_amount_group_OANDA_spot_currency,
    -- Product In Stock Amounts
    product_in_stock_amount_functional_currency,
    product_in_stock_amount_group_conso_EOM_currency,
    product_in_stock_amount_group_OANDA_spot_currency,
    -- Sales
    stock_sales_last_3_months_transactional_currency,
    stock_sales_last_3_months_functional_currency,
    stock_sales_last_3_months_group_conso_AVG_currency,
    stock_sales_last_3_months_group_OANDA_spot_currency,
    -- Fact Attributes
    CAST(brg.stock_lot_number AS VARCHAR(255)) AS stock_lot_number,
    CAST(brg.stock_uom AS VARCHAR(255)) AS stock_uom,
    brg.stock_warehouse_name,
    CASE 
        WHEN bkey_source = 'DYNAMICS' THEN 'Weekly'
        WHEN bkey_source = 'STG_STOCK' THEN 'Monthly'
        ELSE 'Unknown'
    END AS snapshot_granularity,
    brg.bkey_source AS source

FROM {{ ref('bv_brg_stock') }} brg
LEFT JOIN {{ ref('dim_date') }} entd
    ON brg.entry_date = entd.date
LEFT JOIN {{ ref('dim_date') }} snad
    ON brg.snapshot_date = snad.date
LEFT JOIN {{ ref('dim_company') }} com
    ON brg.bkey_company = com.bkey_company
    AND (com.valid_from <= brg.snapshot_date OR com.valid_from IS NULL)
    AND (com.valid_to > brg.snapshot_date OR com.valid_to IS NULL)
LEFT JOIN {{ ref('dim_customer') }} cus
    ON brg.bkey_customer = cus.bkey_customer
    AND (cus.valid_from <= brg.snapshot_date OR cus.valid_from IS NULL)
    AND (cus.valid_to > brg.snapshot_date OR cus.valid_to IS NULL)
LEFT JOIN {{ ref('dim_currency') }} cur
    ON brg.bkey_currency = cur.bkey_currency
LEFT JOIN {{ ref('dim_product') }} pro
    ON brg.bkey_product = pro.bkey_product
LEFT JOIN {{ ref('dim_product_global') }} prog
    ON brg.bkey_product_global = prog.bkey_product_global
LEFT JOIN {{ ref("dim_stock_age_group") }} sag 
    ON DATEDIFF(DAY, brg.entry_date, brg.snapshot_date) BETWEEN sag.stock_age_group_min_days AND sag.stock_age_group_max_days
LEFT JOIN {{ ref('dim_site') }} sit
    ON brg.bkey_site = sit.bkey_site
