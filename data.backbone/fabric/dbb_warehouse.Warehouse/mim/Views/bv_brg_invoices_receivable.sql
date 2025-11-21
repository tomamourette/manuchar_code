-- Auto Generated (Do not modify) C5D068871F9DA3F3194D7B383D704F98A1D5510823934718827FEBE33B08983A
create view "mim"."bv_brg_invoices_receivable" as -- Sales Last 3 Weeks per Customer
WITH sales_snapshots_per_customer AS (
    SELECT 
        inv.sales_invoice_company,
        inv.sales_invoice_customer_id,
        CAST(inv.sales_invoice_date AS DATE) AS sales_invoice_date,
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
        inv.sales_invoice_customer_id,
        CAST(inv.sales_invoice_date AS DATE)
),

sales_last_3_weeks AS (
    SELECT 
        a.sales_invoice_company,
        a.sales_invoice_customer_id,
        SUM(b.sales_invoice_line_amount_trans_cur) AS sales_last_3_weeks_trans_cur,
        SUM(b.sales_invoice_line_amount_func_cur) AS sales_last_3_weeks_func_cur,
        SUM(b.sales_invoice_line_amount_group_cur_conso_avg) AS sales_last_3_weeks_group_cur_conso_avg,
        SUM(b.sales_invoice_line_amount_group_cur_oanda_eod) AS sales_last_3_weeks_group_cur_oanda_eod
    FROM sales_snapshots_per_customer a
    LEFT JOIN sales_snapshots_per_customer b
        ON a.sales_invoice_company = b.sales_invoice_company
        AND a.sales_invoice_customer_id = b.sales_invoice_customer_id
        AND b.sales_invoice_date BETWEEN DATEADD(day, -21, a.sales_invoice_date) AND a.sales_invoice_date
    GROUP BY 
        a.sales_invoice_company,
        a.sales_invoice_customer_id
),

-- ONPREM
onprem_invoices_per_snapshot AS (
    SELECT  
        inv.bkey_sales_invoice,
        inv.bkey_source,
        -- Date Keys
        inv.sales_invoice_date AS invoice_date,
        inv.sales_invoice_due_date AS due_date,
        inv.sales_invoice_closure_date AS snapshot_date,
        inv.sales_invoice_closed AS settlement_date,
        -- Dimension Keys
        TRIM(inv.sales_invoice_company) AS bkey_company,
        CONCAT(TRIM(inv.sales_invoice_company), '_', TRIM(inv.sales_invoice_customer_id)) AS bkey_customer,
        CASE 
            WHEN inv.sales_invoice_transactional_currency_code = 'XOF' THEN 'CFA'
            WHEN inv.sales_invoice_transactional_currency_code = 'RMB' THEN 'CNY'
            ELSE inv.sales_invoice_transactional_currency_code
        END AS bkey_currency_transactional,
        inv.sales_invoice_group_currency_code AS bkey_currency_group,
        inv.sales_invoice_functional_currency_code AS bkey_currency_functional,
        inv.sales_invoice_payment_schedule AS bkey_payment_term,
        inv.sales_invoice_industry_code AS bkey_customer_industry_invoice,
        -- Numerical Fields
        -- Invoice Amounts
        inv.sales_invoice_amount_trans_cur AS [AR_invoice_amount_transactional_currency],
        inv.sales_invoice_amount_func_cur AS [AR_invoice_amount_functional_currency],
        inv.sales_invoice_amount_group_cur_conso_eom AS [AR_invoice_amount_group_conso_EOM_currency],
        inv.sales_invoice_amount_group_cur_oanda_eod AS [AR_invoice_amount_group_OANDA_spot_currency],
        -- Open Amounts
        inv.sales_invoice_open_amount_trans_cur AS [AR_open_amount_transactional_currency],
        inv.sales_invoice_open_amount_func_cur AS [AR_open_amount_functional_currency],
        inv.sales_invoice_open_amount_group_cur_conso_eom AS [AR_open_amount_group_conso_EOM_currency],
        inv.sales_invoice_open_amount_group_cur_oanda_eod AS [AR_open_amount_group_OANDA_spot_currency],
        -- Settled Amounts
        inv.sales_invoice_settled_amount_trans_cur AS [AR_settled_amount_transactional_currency],
        inv.sales_invoice_settled_amount_func_cur AS [AR_settled_amount_functional_currency],
        inv.sales_invoice_settled_amount_group_cur_conso_eom AS [AR_settled_amount_group_conso_EOM_currency],
        inv.sales_invoice_settled_amount_group_cur_oanda_eod AS [AR_settled_amount_group_OANDA_spot_currency],
        -- Currency Rates
        inv.sales_invoice_group_cur_conso_eom_rate,
        inv.sales_invoice_group_cur_conso_avg_rate,
        inv.sales_invoice_func_cur_rate,
        -- Fact Fields
        inv.sales_invoice_id AS invoice_number,
        inv.sales_invoice_customer_vat AS legal_number,
        -- Sales
        slw.sales_last_3_weeks_trans_cur AS [AR_sales_last_3_weeks_transactional_currency],
        slw.sales_last_3_weeks_func_cur AS [AR_sales_last_3_weeks_functional_currency],
        slw.sales_last_3_weeks_group_cur_conso_avg AS [AR_sales_last_3_weeks_group_conso_AVG_currency],
        slw.sales_last_3_weeks_group_cur_oanda_eod AS [AR_sales_last_3_weeks_group_OANDA_spot_currency]

    FROM "dbb_warehouse"."mim"."bv_sales_invoice" inv
    LEFT JOIN sales_last_3_weeks slw
        ON inv.sales_invoice_company = slw.sales_invoice_company
        AND inv.sales_invoice_customer_id = slw.sales_invoice_customer_id
    WHERE inv.bkey_source = 'STG_AR'
    AND YEAR(sales_invoice_closure_date) >= '2023'
),


-- DYNAMICS
-- Weekly snapshot calendar (adjustable to daily snapshots for incremental loading)
weekly_calendar AS (
    SELECT [date] AS snapshot_date
    FROM "dbb_warehouse"."mim"."bv_date"
    WHERE day_name_long = 'Friday'
), 

-- Accumulate settled amounts across snapshots
-- Use the settlement date as the invoice end date if available, 
-- otherwise default to the current snapshot range (i.e., keep invoice open)
dynamics_accumulated_invoices AS (
    SELECT 
        *,
        SUM(sales_invoice_settled_amount_trans_cur) OVER (
            PARTITION BY bkey_sales_invoice
            ORDER BY valid_from
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS accumulated_settled_amount_trans_cur,
        SUM(sales_invoice_settled_amount_func_cur) OVER (
            PARTITION BY bkey_sales_invoice
            ORDER BY valid_from
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS accumulated_settled_amount_func_cur,
        SUM(sales_invoice_settled_amount_group_cur_conso_eom) OVER (
            PARTITION BY bkey_sales_invoice
            ORDER BY valid_from
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS accumulated_settled_amount_group_cur_conso_eom,
        SUM(sales_invoice_settled_amount_group_cur_oanda_eod) OVER (
            PARTITION BY bkey_sales_invoice
            ORDER BY valid_from
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS accumulated_settled_amount_group_cur_oanda_eod,
        -- Replace valid_from with invoice_date for the first row per invoice
        CASE 
            WHEN ROW_NUMBER() OVER (PARTITION BY bkey_sales_invoice ORDER BY valid_from) = 1 
            THEN sales_invoice_date 
            ELSE valid_from 
        END AS new_valid_from,
        -- Replace valid_to with settlement date if it exists, otherwise take current date
        CAST(COALESCE(valid_to, sales_invoice_closed, GETDATE()) AS DATETIME2(2)) AS new_valid_to
    FROM "dbb_warehouse"."mim"."bv_sales_invoice"
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
        inv.bkey_sales_invoice,
        inv.bkey_source,
        -- Date Keys
        MAX(
            IIF(
                LEFT(inv.sales_invoice_txt, 2) = 'OB' AND inv.sales_invoice_document_date = '',
                inv.sales_invoice_date,
                IIF(LEFT(inv.sales_invoice_txt, 2) = 'OB', inv.sales_invoice_document_date, inv.sales_invoice_date)
            )
        ) AS invoice_date,
        MAX(inv.sales_invoice_due_date) AS due_date,
        cal.snapshot_date,
        MAX(inv.sales_invoice_closed) AS settlement_date,
        -- Dimension Keys
        CASE 
            WHEN MAX(TRIM(UPPER(inv.sales_invoice_company))) = 'LDI' THEN 'LDINT'
            ELSE MAX(TRIM(UPPER(inv.sales_invoice_company)))
        END AS bkey_company,
        CONCAT(
            MAX(TRIM(UPPER(inv.sales_invoice_company))), '_', MAX(TRIM(inv.sales_invoice_customer_id))
        ) AS bkey_customer,
        MAX(inv.sales_invoice_transactional_currency_code) AS bkey_currency_transactional,
        MAX(inv.sales_invoice_group_currency_code) AS bkey_currency_group,
        MAX(inv.sales_invoice_functional_currency_code) AS bkey_currency_functional,
        MAX(
            COALESCE(
                inv.sales_invoice_payment,
                inv.sales_invoice_payment_schedule,
                IIF(
                    LEFT(inv.sales_invoice_payment_reference, 3) IN ('BD-', 'CA-', 'DC-', 'OA-', 'OT-', 'PP-'),
                    inv.sales_invoice_payment_reference,
                    NULL
                )
            )
        ) AS bkey_payment_term,
        MAX(inv.sales_invoice_industry_code) AS bkey_customer_industry_invoice,
        -- Numerical Fields
        -- Invoice Amounts
        MAX(inv.sales_invoice_amount_trans_cur) AS [AR_invoice_amount_transactional_currency],
        MAX(inv.sales_invoice_amount_func_cur) AS [AR_invoice_amount_functional_currency],
        MAX(inv.sales_invoice_amount_group_cur_conso_eom) AS [AR_invoice_amount_group_conso_EOM_currency],
        MAX(inv.sales_invoice_amount_group_cur_oanda_eod) AS [AR_invoice_amount_group_OANDA_spot_currency],
        -- Open Amounts
        MAX(inv.sales_invoice_open_amount_trans_cur) AS [AR_open_amount_transactional_currency],
        MAX(inv.sales_invoice_open_amount_func_cur) AS [AR_open_amount_functional_currency],
        MAX(inv.sales_invoice_open_amount_group_cur_conso_eom) AS [AR_open_amount_group_conso_EOM_currency],
        MAX(inv.sales_invoice_open_amount_group_cur_oanda_eod) AS [AR_open_amount_group_OANDA_spot_currency],
        -- Settled Amounts
        MAX(inv.accumulated_settled_amount_trans_cur) AS [AR_settled_amount_transactional_currency],
        MAX(inv.accumulated_settled_amount_func_cur) AS [AR_settled_amount_functional_currency],
        MAX(inv.accumulated_settled_amount_group_cur_conso_eom) AS [AR_settled_amount_group_conso_EOM_currency],
        MAX(inv.accumulated_settled_amount_group_cur_oanda_eod) AS [AR_settled_amount_group_OANDA_spot_currency],
        -- Currency Rates
        MAX(inv.sales_invoice_group_cur_conso_eom_rate) AS [sales_invoice_group_cur_conso_eom_rate],
        MAX(inv.sales_invoice_group_cur_conso_avg_rate) AS [sales_invoice_group_cur_conso_avg_rate],
        MAX(inv.sales_invoice_func_cur_rate) AS [sales_invoice_func_cur_rate],
        -- Fact Fields
        MAX(inv.sales_invoice_id) AS invoice_number,
        MAX(inv.sales_invoice_customer_vat) AS legal_number,
        -- Sales
        NULL AS [AR_sales_last_3_weeks_transactional_currency],
        NULL AS [AR_sales_last_3_weeks_functional_currency],
        NULL AS [AR_sales_last_3_weeks_group_conso_AVG_currency],
        NULL AS [AR_sales_last_3_weeks_group_OANDA_spot_currency]

    FROM dynamics_filtered_invoices inv
    JOIN weekly_calendar cal
        ON CAST(inv.new_valid_from AS DATE) <= cal.snapshot_date
        AND cal.snapshot_date < CAST(inv.new_valid_to AS DATE)

    GROUP BY cal.snapshot_date, inv.bkey_sales_invoice, inv.bkey_source
)

SELECT 
    bkey_sales_invoice,
    bkey_source,
    invoice_date,
    due_date,
    snapshot_date,
    settlement_date,
    bkey_company,
    bkey_customer,
    bkey_currency_transactional,
    bkey_currency_group,
    bkey_currency_functional,
    bkey_payment_term,
    bkey_customer_industry_invoice,
    AR_invoice_amount_transactional_currency,
    AR_invoice_amount_functional_currency,
    AR_invoice_amount_group_conso_EOM_currency,
    AR_invoice_amount_group_OANDA_spot_currency,

    AR_open_amount_transactional_currency,
    AR_open_amount_functional_currency,
    AR_open_amount_group_conso_EOM_currency,
    AR_open_amount_group_OANDA_spot_currency,

    AR_settled_amount_transactional_currency,
    AR_settled_amount_functional_currency,
    AR_settled_amount_group_conso_EOM_currency,
    AR_settled_amount_group_OANDA_spot_currency,

    sales_invoice_group_cur_conso_eom_rate,
    sales_invoice_group_cur_conso_avg_rate,
    sales_invoice_func_cur_rate,

    invoice_number,
    legal_number,
    
    CAST(AR_sales_last_3_weeks_transactional_currency AS DECIMAL) AS AR_sales_last_3_weeks_transactional_currency,
    CAST(AR_sales_last_3_weeks_functional_currency AS DECIMAL) AS AR_sales_last_3_weeks_functional_currency,
    CAST(AR_sales_last_3_weeks_group_conso_AVG_currency AS DECIMAL) AS AR_sales_last_3_weeks_group_conso_AVG_currency,
    CAST(AR_sales_last_3_weeks_group_OANDA_spot_currency AS DECIMAL) AS AR_sales_last_3_weeks_group_OANDA_spot_currency

FROM dynamics_invoices_per_snapshot

UNION ALL

SELECT 
    bkey_sales_invoice,
    bkey_source,
    invoice_date,
    due_date,
    snapshot_date,
    settlement_date,
    bkey_company,
    bkey_customer,
    bkey_currency_transactional,
    bkey_currency_group,
    bkey_currency_functional,
    bkey_payment_term,
    bkey_customer_industry_invoice,
    AR_invoice_amount_transactional_currency,
    AR_invoice_amount_functional_currency,
    AR_invoice_amount_group_conso_EOM_currency,
    AR_invoice_amount_group_OANDA_spot_currency,

    AR_open_amount_transactional_currency,
    AR_open_amount_functional_currency,
    AR_open_amount_group_conso_EOM_currency,
    AR_open_amount_group_OANDA_spot_currency,

    AR_settled_amount_transactional_currency,
    AR_settled_amount_functional_currency,
    AR_settled_amount_group_conso_EOM_currency,
    AR_settled_amount_group_OANDA_spot_currency,

    sales_invoice_group_cur_conso_eom_rate,
    sales_invoice_group_cur_conso_avg_rate,
    sales_invoice_func_cur_rate,

    invoice_number,
    legal_number,
    
    CAST(AR_sales_last_3_weeks_transactional_currency AS DECIMAL) AS AR_sales_last_3_weeks_transactional_currency,
    CAST(AR_sales_last_3_weeks_functional_currency AS DECIMAL) AS AR_sales_last_3_weeks_functional_currency,
    CAST(AR_sales_last_3_weeks_group_conso_AVG_currency AS DECIMAL) AS AR_sales_last_3_weeks_group_conso_AVG_currency,
    CAST(AR_sales_last_3_weeks_group_OANDA_spot_currency AS DECIMAL) AS AR_sales_last_3_weeks_group_OANDA_spot_currency

FROM onprem_invoices_per_snapshot;