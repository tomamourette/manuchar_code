-- Auto Generated (Do not modify) 3E8E6A48EF175C31CC1E285D4B0D38667D355275DC7E316DDF0D1A73A69AA867
create view "mim"."bv_brg_invoices_payable" as -- ONPREM
WITH onprem_invoices_per_snapshot AS (
    SELECT  
        bkey_invoice_payable,
        bkey_source,
        -- Date Keys
        inv.invoice_payable_due_date AS due_date,
        inv.invoice_payable_closure_date AS snapshot_date,
        inv.invoice_payable_invoice_date AS invoice_date,
        NULL AS settlement_date,
        -- Dimension Keys
        inv.invoice_payable_company AS bkey_company,
        CONCAT(inv.invoice_payable_company, '_', inv.invoice_payable_supplier_id) AS bkey_supplier,
        CASE 
            WHEN inv.invoice_payable_local_currency_code = 'XOF' THEN 'CFA'
            WHEN inv.invoice_payable_local_currency_code = 'RMB' THEN 'CNY'
            ELSE inv.invoice_payable_local_currency_code
        END AS bkey_currency,
        inv.invoice_payable_payment_schedule AS bkey_payment_term,
        NULL AS bkey_customer_industry_invoice,
        -- Numerical Fields
        
        -- Invoice Amounts
        inv.invoice_payable_amount_trans_cur AS [AP_invoice_amount_transactional_currency],
        inv.invoice_payable_amount_func_cur AS [AP_invoice_amount_functional_currency],
        inv.invoice_payable_amount_group_cur_conso_eom AS [AP_invoice_amount_group_conso_EOM_currency],
        inv.invoice_payable_amount_group_cur_oanda_eod AS [AP_invoice_amount_group_OANDA_spot_currency],
        -- Open Amounts
        inv.invoice_payable_open_amount_trans_cur AS [AP_open_amount_transactional_currency],
        inv.invoice_payable_open_amount_func_cur AS [AP_open_amount_functional_currency],
        inv.invoice_payable_open_amount_group_cur_conso_eom AS [AP_open_amount_group_conso_EOM_currency],
        inv.invoice_payable_open_amount_group_cur_oanda_eod AS [AP_open_amount_group_OANDA_spot_currency],
        -- Settled Amounts
        inv.invoice_payable_settled_amount_trans_cur AS [AP_settled_amount_transactional_currency],
        inv.invoice_payable_settled_amount_func_cur AS [AP_settled_amount_functional_currency],
        inv.invoice_payable_settled_amount_group_cur_conso_eom AS [AP_settled_amount_group_conso_EOM_currency],
        inv.invoice_payable_settled_amount_group_cur_oanda_eod AS [AP_settled_amount_group_OANDA_spot_currency],

        -- Fact Fields
        inv.invoice_payable_invoice_id AS invoice_number,
        NULL AS legal_number

    FROM "dbb_warehouse"."mim"."bv_invoice_payable" inv
    WHERE inv.bkey_source = 'STG_AP'
    AND YEAR(invoice_payable_closure_date) >= '2023'
),

-- DYNAMICS
-- Weekly snapshot calendar (adjustable to daily snapshots for incremental loading)
weekly_calendar AS (
    SELECT [date] AS snapshot_date
    FROM "dbb_warehouse"."mim"."bv_date"
    WHERE day_name_long = 'Friday'
), 

dynamics_accumulated_invoices AS (
    SELECT 
        *,
        SUM(purchase_invoice_settled_amount_trans_cur) OVER (
            PARTITION BY bkey_purchase_invoice
            ORDER BY valid_from
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS accumulated_settled_amount_trans_cur,
        SUM(purchase_invoice_settled_amount_func_cur) OVER (
            PARTITION BY bkey_purchase_invoice
            ORDER BY valid_from
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS accumulated_settled_amount_func_cur,
        SUM(purchase_invoice_settled_amount_group_cur_conso_eom) OVER (
            PARTITION BY bkey_purchase_invoice
            ORDER BY valid_from
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS accumulated_settled_amount_group_cur_conso_eom,
        SUM(purchase_invoice_settled_amount_group_cur_oanda_eod) OVER (
            PARTITION BY bkey_purchase_invoice
            ORDER BY valid_from
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS accumulated_settled_amount_group_cur_oanda_eod,
        -- Replace valid_from with invoice_date for the first row per invoice
        CASE 
            WHEN ROW_NUMBER() OVER (PARTITION BY bkey_purchase_invoice ORDER BY valid_from) = 1 
            THEN purchase_invoice_date 
            ELSE valid_from 
        END AS new_valid_from,
        -- Replace valid_to with settlement date if it exists, otherwise take current date
        CAST(COALESCE(valid_to, purchase_invoice_closed, GETDATE()) AS DATETIME2(2)) AS new_valid_to
    FROM "dbb_warehouse"."mim"."bv_purchase_invoice"
    WHERE bkey_source = 'DYNAMICS'
),

-- Filter out accumulated settlements before 2023
dynamics_filtered_invoices AS (
    SELECT 
        *
    FROM dynamics_accumulated_invoices
    WHERE YEAR(new_valid_to) >= '2023'
),

-- Join Calendar for Accumulated Invoices per Snapshot
dynamics_invoices_per_snapshot AS (
    SELECT
        inv.bkey_purchase_invoice,
        inv.bkey_source,
        -- Date Keys
        MAX(purchase_invoice_date) AS invoice_date,
        MAX(inv.purchase_invoice_due_date) AS due_date,
        cal.snapshot_date,
        MAX(inv.purchase_invoice_closed) AS settlement_date,
        -- Dimension Keys
        CASE 
            WHEN MAX(TRIM(UPPER(inv.purchase_invoice_company))) = 'LDI' THEN 'LDINT'
            ELSE MAX(TRIM(UPPER(inv.purchase_invoice_company)))
        END AS bkey_company,
        CONCAT(
            MAX(TRIM(UPPER(inv.purchase_invoice_company))), '_', MAX(TRIM(inv.purchase_invoice_supplier_id))
        ) AS bkey_supplier,
        MAX(inv.purchase_invoice_local_currency_code) AS bkey_currency,
        MAX(COALESCE(inv.purchase_invoice_payment, inv.purchase_invoice_payment_schedule)) AS bkey_payment_term,
        MAX(inv.purchase_invoice_industry_code) AS bkey_customer_industry_invoice,
        -- Numerical Fields
        
        -- Invoice Amounts
        MAX(inv.purchase_invoice_amount_trans_cur) AS [AP_invoice_amount_transactional_currency],
        MAX(inv.purchase_invoice_amount_func_cur) AS [AP_invoice_amount_functional_currency],
        MAX(inv.purchase_invoice_amount_group_cur_conso_eom) AS [AP_invoice_amount_group_conso_EOM_currency],
        MAX(inv.purchase_invoice_amount_group_cur_oanda_eod) AS [AP_invoice_amount_group_OANDA_spot_currency],
        -- Open Amounts
        MAX(inv.purchase_invoice_open_amount_trans_cur) AS [AP_open_amount_transactional_currency],
        MAX(inv.purchase_invoice_open_amount_func_cur) AS [AP_open_amount_functional_currency],
        MAX(inv.purchase_invoice_open_amount_group_cur_conso_eom) AS [AP_open_amount_group_conso_EOM_currency],
        MAX(inv.purchase_invoice_open_amount_group_cur_oanda_eod) AS [AP_open_amount_group_OANDA_spot_currency],
        -- Settled Amounts
        MAX(inv.accumulated_settled_amount_trans_cur) AS [AP_settled_amount_transactional_currency],
        MAX(inv.accumulated_settled_amount_func_cur) AS [AP_settled_amount_functional_currency],
        MAX(inv.accumulated_settled_amount_group_cur_conso_eom) AS [AP_settled_amount_group_conso_EOM_currency],
        MAX(inv.accumulated_settled_amount_group_cur_oanda_eod) AS [AP_settled_amount_group_OANDA_spot_currency],

        -- Fact Fields
        MAX(inv.purchase_invoice_id) AS invoice_number,
        MAX(inv.purchase_invoice_legal_number) AS legal_number,
        -- Sales
        NULL AS last_3_week_sales_home_group

    FROM dynamics_filtered_invoices inv
    JOIN weekly_calendar cal
        ON CAST(inv.new_valid_from AS DATE) <= cal.snapshot_date
        AND cal.snapshot_date < CAST(inv.new_valid_to AS DATE)

    GROUP BY cal.snapshot_date, inv.bkey_purchase_invoice, inv.bkey_source
)

SELECT 
    bkey_invoice_payable AS bkey_purchase_invoice,
    bkey_source,
    invoice_date,
    due_date,
    snapshot_date,
    settlement_date,
    bkey_company,
    bkey_supplier,
    bkey_currency,
    bkey_payment_term,
    bkey_customer_industry_invoice,

    AP_invoice_amount_transactional_currency,
    AP_invoice_amount_functional_currency,
    AP_invoice_amount_group_conso_EOM_currency,
    AP_invoice_amount_group_OANDA_spot_currency,

    AP_open_amount_transactional_currency,
    AP_open_amount_functional_currency,
    AP_open_amount_group_conso_EOM_currency,
    AP_open_amount_group_OANDA_spot_currency,

    AP_settled_amount_transactional_currency,
    AP_settled_amount_functional_currency,
    AP_settled_amount_group_conso_EOM_currency,
    AP_settled_amount_group_OANDA_spot_currency,
    
    invoice_number,
    legal_number
FROM onprem_invoices_per_snapshot

UNION ALL

SELECT 
    bkey_purchase_invoice,
    bkey_source,
    invoice_date,
    due_date,
    snapshot_date,
    settlement_date,
    bkey_company,
    bkey_supplier,
    bkey_currency,
    bkey_payment_term,
    bkey_customer_industry_invoice,
    
    AP_invoice_amount_transactional_currency,
    AP_invoice_amount_functional_currency,
    AP_invoice_amount_group_conso_EOM_currency,
    AP_invoice_amount_group_OANDA_spot_currency,

    AP_open_amount_transactional_currency,
    AP_open_amount_functional_currency,
    AP_open_amount_group_conso_EOM_currency,
    AP_open_amount_group_OANDA_spot_currency,

    AP_settled_amount_transactional_currency,
    AP_settled_amount_functional_currency,
    AP_settled_amount_group_conso_EOM_currency,
    AP_settled_amount_group_OANDA_spot_currency,

    invoice_number,
    legal_number
FROM dynamics_invoices_per_snapshot;