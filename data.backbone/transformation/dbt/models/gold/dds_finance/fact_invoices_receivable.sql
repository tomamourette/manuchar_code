SELECT 
    invd.tkey_date AS tkey_invoice_date,
    dued.tkey_date AS tkey_due_date,
    clod.tkey_date AS tkey_snapshot_date,
    com.tkey_company,
    cus.tkey_customer,
    cur.tkey_currency,
    pay.tkey_payment_term,
    ind.tkey_customer_industry_invoice,
    ag.tkey_age_group,
    
    -- Invoice Amounts
    AR_invoice_amount_transactional_currency,
    AR_invoice_amount_functional_currency,
    AR_invoice_amount_group_conso_EOM_currency,
    AR_invoice_amount_group_OANDA_spot_currency,
    -- Open Amounts
    AR_open_amount_transactional_currency,
    AR_open_amount_functional_currency,
    AR_open_amount_group_conso_EOM_currency,
    AR_open_amount_group_OANDA_spot_currency,
    -- Settled Amounts
    AR_settled_amount_transactional_currency,
    AR_settled_amount_functional_currency,
    AR_settled_amount_group_conso_EOM_currency,
    AR_settled_amount_group_OANDA_spot_currency,
    -- Sales Amounts
    AR_sales_last_3_weeks_transactional_currency,
    AR_sales_last_3_weeks_functional_currency,
    AR_sales_last_3_weeks_group_conso_AVG_currency,
    AR_sales_last_3_weeks_group_OANDA_spot_currency,
    
    CAST(brg.invoice_number AS VARCHAR(50)) AS invoice_number,
    CAST(brg.legal_number AS VARCHAR(50)) AS legal_number,
    CAST(brg.settlement_date AS DATETIME2(6)) AS settlement_date,
    CASE
        WHEN ABS(brg.AR_invoice_amount_transactional_currency) = ABS(brg.AR_settled_amount_transactional_currency) AND brg.AR_settled_amount_transactional_currency != 0 AND brg.AR_open_amount_transactional_currency = 0 THEN 'Paid'
        WHEN ABS(brg.AR_open_amount_transactional_currency) <> ABS(brg.AR_invoice_amount_transactional_currency) AND brg.AR_settled_amount_transactional_currency != 0 THEN 'Partially Paid'
        ELSE 'Open'
    END AS status,
    CASE 
        WHEN brg.AR_invoice_amount_transactional_currency = 0 THEN 0
        ELSE ROUND((brg.AR_settled_amount_transactional_currency / brg.AR_invoice_amount_transactional_currency) * 100, 2)
    END AS payment_progress_percentage,

    CASE 
        WHEN brg.bkey_source = 'DYNAMICS' THEN 'Weekly'
        WHEN brg.bkey_source = 'STG_AR' THEN 'Monthly'
        ELSE 'Unknown'
    END AS snapshot_granularity,
    brg.bkey_source AS source

FROM {{ ref('bv_brg_invoices_receivable') }} brg
LEFT JOIN {{ ref('dim_date') }} invd
    ON brg.invoice_date = invd.date
LEFT JOIN {{ ref('dim_date') }} dued
    ON brg.due_date = dued.date
LEFT JOIN {{ ref('dim_date') }} clod
    ON brg.snapshot_date = clod.date
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
LEFT JOIN {{ ref("dim_age_group") }} ag 
    ON DATEDIFF(DAY, brg.due_date, brg.snapshot_date) BETWEEN ag.age_group_min_days AND ag.age_group_max_days
LEFT JOIN {{ ref('dim_payment_term') }} pay
    ON brg.bkey_payment_term = pay.bkey_payment_term
LEFT JOIN {{ ref('dim_customer_industry_invoice') }} ind
    ON brg.bkey_customer_industry_invoice = ind.bkey_customer_industry_invoice