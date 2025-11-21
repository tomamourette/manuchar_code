SELECT 
    invd.tkey_date AS tkey_invoice_date,
    dued.tkey_date AS tkey_due_date,
    clod.tkey_date AS tkey_snapshot_date,
    com.tkey_company,
    sup.tkey_supplier,
    cur.tkey_currency,
    pay.tkey_payment_term,
    ind.tkey_customer_industry_invoice,
    ag.tkey_age_group,
    -- Invoice Amounts
    AP_invoice_amount_transactional_currency,
    AP_invoice_amount_functional_currency,
    AP_invoice_amount_group_conso_EOM_currency,
    AP_invoice_amount_group_OANDA_spot_currency,
    -- Open Amounts
    AP_open_amount_transactional_currency,
    AP_open_amount_functional_currency,
    AP_open_amount_group_conso_EOM_currency,
    AP_open_amount_group_OANDA_spot_currency,
    -- Settled Amounts
    AP_settled_amount_transactional_currency,
    AP_settled_amount_functional_currency,
    AP_settled_amount_group_conso_EOM_currency,
    AP_settled_amount_group_OANDA_spot_currency,
    
    CAST(brg.invoice_number AS VARCHAR(50)) AS invoice_number,
    CAST(brg.legal_number AS VARCHAR(50)) AS legal_number,
    CAST(brg.settlement_date AS DATETIME2(6)) AS settlement_date,
    CASE
        WHEN ABS(brg.AP_invoice_amount_transactional_currency) = ABS(brg.AP_settled_amount_transactional_currency) AND brg.AP_settled_amount_transactional_currency != 0 AND brg.AP_open_amount_transactional_currency = 0 THEN 'Paid'
        WHEN ABS(brg.AP_open_amount_transactional_currency) <> ABS(brg.AP_invoice_amount_transactional_currency) AND brg.AP_settled_amount_transactional_currency != 0 THEN 'Partially Paid'
        ELSE 'Open'
    END AS status,
    CASE 
        WHEN brg.AP_invoice_amount_transactional_currency = 0 THEN 0
        ELSE ROUND((brg.AP_settled_amount_transactional_currency / brg.AP_invoice_amount_transactional_currency) * 100, 2)
    END AS payment_progress_percentage,

    CASE 
        WHEN brg.bkey_source = 'DYNAMICS' THEN 'Weekly'
        WHEN brg.bkey_source = 'STG_AP' THEN 'Monthly'
        ELSE 'Unknown'
    END AS snapshot_granularity,
    brg.bkey_source AS source

FROM {{ ref('bv_brg_invoices_payable') }} brg
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
LEFT JOIN {{ ref('dim_supplier') }} sup
    ON brg.bkey_supplier = sup.bkey_supplier
    AND (sup.valid_from <= brg.snapshot_date OR sup.valid_from IS NULL)
    AND (sup.valid_to > brg.snapshot_date OR sup.valid_to IS NULL)
LEFT JOIN {{ ref('dim_currency') }} cur
    ON brg.bkey_currency = cur.bkey_currency
LEFT JOIN {{ ref("dim_age_group") }} ag 
    ON DATEDIFF(DAY, brg.due_date, brg.snapshot_date) BETWEEN ag.age_group_min_days AND ag.age_group_max_days
LEFT JOIN {{ ref('dim_payment_term') }} pay
    ON brg.bkey_payment_term = pay.bkey_payment_term
LEFT JOIN {{ ref('dim_customer_industry_invoice') }} ind
    ON brg.bkey_customer_industry_invoice = ind.bkey_customer_industry_invoice
-- Rate conversion
LEFT JOIN {{ ref('bv_currency_rate') }} hgc 
    ON hgc.currency_rate_consolidation_code = 
        CASE 
            WHEN clod.month_key < '202501' THEN CONCAT(clod.month_key, 'ACT000') -- IFR100 is leading period from 202501 onwards
            ELSE CONCAT(clod.month_key, 'IFR100')
        END
    AND hgc.currency_rate_currency_code = com.company_home_currency
LEFT JOIN {{ ref('bv_currency_rate') }} lgc 
    ON lgc.currency_rate_consolidation_code = 
        CASE 
            WHEN clod.month_key < '202501' THEN CONCAT(clod.month_key, 'ACT000') -- IFR100 is leading period from 202501 onwards
            ELSE CONCAT(clod.month_key, 'IFR100')
        END
    AND lgc.currency_rate_currency_code = brg.bkey_currency