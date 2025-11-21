-- ===============================
-- STEP 1: Extract Historical Data (SCD2) for Customer Invoices
-- ===============================

WITH vendor_invoice_history AS (
    -- Invoice transaction history with valid timestamps
    SELECT 
        vit.recid, 
        vit.invoiceid,
        vit.linenum,
        vit.qty,
        vit.itemid,
        vit.lineamount,
        vit.lineamountmst,
        vit.invoicedate,
        vit.currencycode,
        vit.dataareaid, 
        vit.purchid,
        vit.name,
        vit.purchunit,
        vit.taxamount,
        CAST(vit.modifieddatetime AS DATETIME2(6)) AS valid_from,
        CAST(LEAD(vit.modifieddatetime) OVER (PARTITION BY vit.recid ORDER BY vit.modifieddatetime) AS DATETIME2(6)) AS valid_to
    FROM {{ ref("sv_dynamics_vendinvoicetrans") }} vit 
    WHERE vit.IsDelete IS NULL
),

vendor_transaction_history AS (
    -- Extract transaction history for invoices with valid timestamps
    SELECT 
        vit.recid, 
        vit.invoiceid,
        vt.recid AS trans_recid,
        vt.duedate,
        vt.voucher,
        vij.ledgervoucher,
        vij.invoiceaccount,
        vt.transdate,
        vt.accountnum,
        vt.paymreference,
        vt.paymtermid,
        vt.closed,
        vt.txt,
        CAST(vt.modifieddatetime AS DATETIME2(6)) AS valid_from,
        CAST(LEAD(vt.modifieddatetime) OVER (PARTITION BY vit.recid ORDER BY vt.modifieddatetime) AS DATETIME2(6)) AS valid_to
    FROM {{ ref("sv_dynamics_vendinvoicetrans") }} vit  
    LEFT JOIN {{ ref("sv_dynamics_vendinvoicejour") }} vij 
        ON vit.purchid = vij.purchid
        AND vit.invoiceid = vij.invoiceid
        AND vit.invoicedate = vij.invoicedate
    LEFT JOIN {{ ref("sv_dynamics_vendtrans") }} vt 
        ON vij.invoiceaccount = vt.accountnum
        AND vij.ledgervoucher = vt.voucher
        AND vij.invoicedate = vt.transdate
        AND vij.invoiceid = vt.invoice
    WHERE vit.IsDelete IS NULL
),

-- ===============================
-- STEP 2: Generate Time Ranges for SCD2 (if needed)
-- ===============================

timeranges AS (
    SELECT 
        recid, 
        CAST(valid_from AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(valid_from) OVER (PARTITION BY recid ORDER BY valid_from), '2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        -- Combine valid_from and valid_to from all sources
        SELECT DISTINCT recid, valid_from, valid_to FROM vendor_invoice_history
        UNION 
        SELECT DISTINCT recid, valid_from, valid_to FROM vendor_transaction_history
    ) AS time_events WHERE valid_from IS NOT NULL
)

-- ===============================
-- STEP 3: Combine Everything into a Full Entity Timeline
-- ===============================


SELECT 
    MAX(tr.recid) AS tkey_purchase_invoice_line_dynamics,
    e1.invoiceid + '_' + CAST(CAST(e1.linenum AS DECIMAL(18, 0)) AS VARCHAR) + '_' + e1.dataareaid + '_DYNAMICS' AS bkey_purchase_invoice_line_source,
    e1.invoiceid + '_' + CAST(CAST(e1.linenum AS DECIMAL(18, 0)) AS VARCHAR) + '_' + e1.dataareaid AS bkey_purchase_invoice_line,
    
    e1.invoiceid + '_' + e1.dataareaid AS bkey_purchase_invoice,
    'DYNAMICS' AS bkey_source,
    e1.linenum AS purchase_invoice_line_number,
    MAX(e1.name) AS purchase_invoice_line_description,
    SUM(e1.qty) AS purchase_invoice_line_quantity,
    MAX(e1.itemid) AS purchase_invoice_line_product_id,
    
    -- Invoice Line Amounts
    SUM(e1.lineamount) AS purchase_invoice_line_amount_trans_cur,
    SUM(e1.lineamountmst) AS purchase_invoice_line_amount_func_cur,
    SUM(e1.lineamount) / NULLIF(MAX(curr.currency_rate_average_month), 0) AS purchase_invoice_line_amount_group_cur_conso_avg,
    NULL AS purchase_invoice_line_amount_group_cur_oanda_eod,
    -- Currency Rates
    NULL AS purchase_invoice_line_group_cur_oanda_eod_rate,
    CASE
        WHEN MAX(curr.currency_rate_average_month) IS NULL OR MAX(curr.currency_rate_average_month) = 0
            THEN 0
        ELSE 1 / MAX(curr.currency_rate_average_month)
    END AS purchase_invoice_line_group_cur_conso_avg_rate,
    CASE
        WHEN MAX(e1.lineamountmst) IS NULL OR MAX(e1.lineamountmst) = 0
            THEN 0
        ELSE MAX(e1.lineamountmst) / MAX(e1.lineamount)
    END AS purchase_invoice_line_func_cur_rate,
    
    MAX(e1.currencycode) AS purchase_invoice_line_transactional_currency_code,
    'USD' AS purchase_invoice_line_group_currency_code,
    CONVERT(VARCHAR, NULL) AS purchase_invoice_line_functional_currency_code,
    e1.dataareaid AS purchase_invoice_line_company,
    MAX(e1.purchunit) AS purchase_invoice_line_UOM,
    MAX(e2.ledgervoucher) AS purchase_invoice_line_ledger_voucher,
    MAX(e2.paymtermid) AS purchase_invoice_line_payment_term_id,
    MAX(e2.closed) AS purchase_invoice_line_closed,
    SUM(e1.taxamount) AS purchase_invoice_line_tax_amount,
    MIN(tr.valid_from) AS valid_from,
    MAX(tr.valid_to) AS valid_to,
    CASE 
        WHEN MAX(tr.valid_to) = '2999-12-31 23:59:59.999999' THEN 1
        ELSE 0
    END AS is_current
FROM timeranges tr
LEFT JOIN vendor_invoice_history e1 
    ON e1.recid = tr.recid 
    AND e1.valid_from <= tr.valid_from 
    AND COALESCE(e1.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
LEFT JOIN vendor_transaction_history e2
    ON e2.recid = tr.recid 
    AND e2.valid_from <= tr.valid_from 
    AND COALESCE(e2.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
LEFT JOIN {{ ref("currency_rate_mona") }} curr
    ON curr.currency_rate_currency_code = e1.currencycode
    AND FORMAT(e1.invoicedate, 'yyyyMM') = FORMAT(curr.currency_rate_closing_date, 'yyyyMM')
GROUP BY 
    e1.invoiceid,
    e1.linenum,
    e1.dataareaid

