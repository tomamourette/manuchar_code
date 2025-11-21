-- Auto Generated (Do not modify) 6F33B0122BFFE4666638A044DC34766BB9C81C46B2B57E0C9F3EE1F815786217
create view "mim"."bv_brg_stock" as -- Sales Last 3 Months per Product
WITH sales_snapshots_per_product AS (
    SELECT 
        inv.sales_invoice_company, 
        invl.sales_invoice_line_product_id,
        inv.sales_invoice_closure_date,
        SUM(invl.sales_invoice_line_amount_trans_cur) AS sales_invoice_line_amount_trans_cur,
        SUM(invl.sales_invoice_line_amount_func_cur) AS sales_invoice_line_amount_func_cur,
        SUM(invl.sales_invoice_line_amount_group_cur_conso_avg) AS sales_invoice_line_amount_group_cur_conso_avg,
        SUM(invl.sales_invoice_line_amount_group_cur_oanda_eod) AS sales_invoice_line_amount_group_cur_oanda_eod
    FROM "dbb_warehouse"."mim"."bv_sales_invoice" inv
	LEFT JOIN "dbb_warehouse"."mim"."bv_sales_invoice_line" invl
    	ON inv.bkey_sales_invoice = invl.bkey_sales_invoice AND invl.bkey_source = 'STG_SALES'
    WHERE inv.bkey_source = 'STG_SALES'
    GROUP BY 
        inv.sales_invoice_company,
        invl.sales_invoice_line_product_id,
        inv.sales_invoice_closure_date
),
sales_last_3_months AS (
    SELECT 
        *,
        SUM(sales_invoice_line_amount_trans_cur) OVER (
            PARTITION BY sales_invoice_company, sales_invoice_line_product_id
            ORDER BY sales_invoice_closure_date
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) AS sales_last_3_months_trans_cur,
        SUM(sales_invoice_line_amount_func_cur) OVER (
            PARTITION BY sales_invoice_company, sales_invoice_line_product_id
            ORDER BY sales_invoice_closure_date
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) AS sales_last_3_months_func_cur,
        SUM(sales_invoice_line_amount_group_cur_conso_avg) OVER (
            PARTITION BY sales_invoice_company, sales_invoice_line_product_id
            ORDER BY sales_invoice_closure_date
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) AS sales_last_3_months_group_cur_conso_avg,
        SUM(sales_invoice_line_amount_group_cur_oanda_eod) OVER (
            PARTITION BY sales_invoice_company, sales_invoice_line_product_id
            ORDER BY sales_invoice_closure_date
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) AS sales_last_3_months_group_cur_oanda_eod
    FROM sales_snapshots_per_product
),

-- ONPREM
stock_stg AS (
    SELECT 
        sto.bkey_stock,
        sto.bkey_source,

        sto.stock_closure_date AS snapshot_date,
        sto.stock_entry_date AS entry_date,
        
        sto.stock_company AS bkey_company,
        CONCAT(sto.stock_company, '_', sto.stock_customer_id) AS bkey_customer,
        sto.stock_currency AS bkey_currency,
        stock_warehouse_name AS bkey_site,
        CONCAT(sto.stock_company, '_', sto.stock_product_id) AS bkey_product,
        sto.stock_product_code AS bkey_product_global,
        
        sto.stock_committed,
        sto.stock_in_transit,
        
        sto.stock_quantity,
        sto.stock_quantity_mt,
        -- Stock Amounts
        sto.stock_amount_func_cur AS [stock_amount_functional_currency]​,
        sto.stock_amount_group_conso_eom AS [stock_amount_group_conso_EOM_currency]​,
        sto.stock_amount_group_oanda_eod AS [stock_amount_group_OANDA_spot_currency],
        -- Product In Stock Amounts
        SUM(stock_amount_func_cur​) OVER (PARTITION BY stock_company, stock_closure_date, stock_product_id) AS [product_in_stock_amount_functional_currency],
        SUM(stock_amount_group_conso_eom​) OVER (PARTITION BY stock_company, stock_closure_date, stock_product_id) AS [product_in_stock_amount_group_conso_EOM_currency],
        SUM(stock_amount_group_oanda_eod) OVER (PARTITION BY stock_company, stock_closure_date, stock_product_id) AS [product_in_stock_amount_group_OANDA_spot_currency],
        -- Sales
        slm.sales_last_3_months_trans_cur AS [stock_sales_last_3_months_transactional_currency],
        slm.sales_last_3_months_func_cur AS [stock_sales_last_3_months_functional_currency],
        slm.sales_last_3_months_group_cur_conso_avg AS [stock_sales_last_3_months_group_conso_AVG_currency],
        slm.sales_last_3_months_group_cur_oanda_eod AS [stock_sales_last_3_months_group_OANDA_spot_currency],
        
        sto.stock_warehouse_name,
        sto.stock_uom,
        sto.stock_lot_number
    
    FROM "dbb_warehouse"."mim"."bv_stock" sto
    LEFT JOIN sales_last_3_months slm
        ON sto.stock_company = slm.sales_invoice_company
        AND sto.stock_product_id = slm.sales_invoice_line_product_id
        AND sto.stock_closure_date = slm.sales_invoice_closure_date
    WHERE sto.bkey_source = 'STG_STOCK'
),

-- DYNAMICS
weekly_calendar AS (
    SELECT [date] AS snapshot_date
    FROM "dbb_warehouse"."mim"."bv_date"
    WHERE day_name_long = 'Friday'
), 

stock_with_snapshots AS (
    SELECT 
        cal.snapshot_date,
        sto.*
    FROM "dbb_warehouse"."mim"."bv_stock" sto
    INNER JOIN weekly_calendar cal 
        ON sto.valid_to >= cal.snapshot_date
        AND sto.valid_from < DATEADD(DAY, 1, cal.snapshot_date)
    WHERE sto.bkey_source = 'DYNAMICS'
),

ranked_stock AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY 
                bkey_stock,  
                snapshot_date
            ORDER BY valid_from DESC  -- take the most recent change for the week
        ) AS rn
    FROM stock_with_snapshots
),

stock_dynamics AS (
    SELECT 
        bkey_stock,
        bkey_source,
        snapshot_date,
        stock_entry_date AS entry_date,
        
        stock_company AS bkey_company,
        CONCAT(stock_company, '_', stock_customer_id) AS bkey_customer,
        stock_currency AS bkey_currency,
        CASE 
            WHEN CHARINDEX('/', stock_invent_location_id) > 0 THEN 
                stock_site_id + '/' + 
                RIGHT(stock_invent_location_id, CHARINDEX('/', REVERSE(stock_invent_location_id)) - 1)
            ELSE stock_site_id
        END AS bkey_site,
        stock_product_id AS bkey_product,
        stock_product_code AS bkey_product_global,

        stock_committed,
        stock_in_transit,
        stock_quantity,
        stock_quantity_mt,
        -- Stock Amounts
        stock_amount_func_cur AS [stock_amount_functional_currency]​,
        stock_amount_group_conso_eom AS [stock_amount_group_conso_EOM_currency]​,
        stock_amount_group_oanda_eod AS [stock_amount_group_OANDA_spot_currency],
        -- Product In Stock Amounts
        SUM(stock_amount_func_cur​) OVER (PARTITION BY stock_company, stock_closure_date, stock_product_id) AS [product_in_stock_amount_functional_currency],
        SUM(stock_amount_group_conso_eom​) OVER (PARTITION BY stock_company, stock_closure_date, stock_product_id) AS [product_in_stock_amount_group_conso_EOM_currency],
        SUM(stock_amount_group_oanda_eod) OVER (PARTITION BY stock_company, stock_closure_date, stock_product_id) AS [product_in_stock_amount_group_OANDA_spot_currency],
        -- Sales
        NULL AS [stock_sales_last_3_months_transactional_currency],
        NULL AS [stock_sales_last_3_months_functional_currency],
        NULL AS [stock_sales_last_3_months_group_conso_AVG_currency],
        NULL AS [stock_sales_last_3_months_group_OANDA_spot_currency],
        
        stock_warehouse_name,
        stock_uom,
        stock_lot_number

    FROM ranked_stock
    WHERE rn = 1
)

SELECT
    *
FROM stock_stg

UNION ALL

SELECT
    *
FROM stock_dynamics;