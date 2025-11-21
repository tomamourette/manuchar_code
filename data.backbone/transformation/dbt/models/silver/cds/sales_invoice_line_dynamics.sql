-- ===============================
-- STEP 1: Extract Historical Data (SCD2) for Customer Invoices
-- ===============================

WITH customer_invoice_history AS (
    -- Invoice transaction history with valid timestamps
    SELECT 
        cit.recid, 
        cit.invoiceid,
        cit.linenum,
        --cit.qty,
        cit.itemid,
        cit.lineamount,
        cit.lineamountmst,
        cit.invoicedate,
        cit.currencycode,
        cit.dataareaid, 
        cit.salesid,
        cit.name,
        cit.salesunit,
        IIF(cit.salesunit = 'bg', cit.qty * CAST(LEFT(invent.inventsizeid, COALESCE(CHARINDEX('kg', invent.inventsizeid), 1)-1) AS INT), cit.qty) AS qty,
        IIF(cit.salesunit = 'bg', cit.qty * CAST(LEFT(invent.inventsizeid, COALESCE(CHARINDEX('kg', invent.inventsizeid), 1)-1) AS INT), cit.qty) / uom.ConversionToMT AS qty_mt,
        IIF(cit.salesunit = 'bg', 'kg', cit.salesunit) AS lineuom,
        CAST(cit.modifieddatetime AS DATETIME2(6)) AS valid_from,
        CAST(LEAD(cit.modifieddatetime) OVER (PARTITION BY cit.recid ORDER BY cit.modifieddatetime) AS DATETIME2(6)) AS valid_to
    FROM {{ ref("sv_dynamics_custinvoicetrans") }} cit 
    LEFT JOIN {{ ref("sv_dynamics_inventsum") }} invent ON invent.itemid = cit.itemid AND invent.inventdimid = cit.inventdimid
    LEFT JOIN  {{ ref("sv_mds_uom") }} uom
        ON UPPER(IIF(cit.salesunit = 'bg', 'kg', cit.salesunit)) = uom.Code
    WHERE cit.IsDelete IS NULL
),

customer_transaction_history AS (
    -- Extract transaction history for invoices with valid timestamps
    SELECT 
        cit.recid, 
        cij.ledgervoucher,
        IIF(cat1.level = 4, cat3.name, cat4.name) AS businessunit,
        CAST(ct.modifieddatetime AS DATETIME2(6)) AS valid_from,
        CAST(LEAD(ct.modifieddatetime) OVER (PARTITION BY cit.recid ORDER BY ct.modifieddatetime) AS DATETIME2(6)) AS valid_to
    FROM {{ ref("sv_dynamics_custinvoicetrans") }} cit  
    LEFT JOIN {{ ref("sv_dynamics_custinvoicejour") }} cij 
        ON cit.salesid = cij.salesid
        AND cit.invoiceid = cij.invoiceid
        AND cit.invoicedate = cij.invoicedate
    LEFT JOIN {{ ref("sv_dynamics_custtrans") }} ct 
        ON ct.accountnum = cij.invoiceaccount
        AND ct.voucher = cij.ledgervoucher
        AND ct.transdate = cij.invoicedate
        AND ct.invoice = cij.invoiceid
    LEFT  JOIN {{ ref("sv_dynamics_ecoresproduct") }} prod ON prod.displayproductnumber = cit.itemid
    LEFT  JOIN {{ ref("sv_dynamics_ecorescategory") }} cat1 ON cat1.recid = prod.recid
    LEFT  JOIN {{ ref("sv_dynamics_ecorescategory") }} cat3 ON cat3.recid = cat1.parentcategory
    LEFT  JOIN {{ ref("sv_dynamics_ecorescategory") }} cat4 ON cat4.recid = cat3.parentcategory
    
    WHERE cit.IsDelete IS NULL
),

-- ===============================
-- STEP 2: Generate Time Ranges for SCD2 (if needed)
-- ===============================

timeranges AS (
    SELECT 
        recid, 
        CAST(valid_from AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(valid_from) OVER (PARTITION BY recid ORDER BY valid_from), '2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM customer_invoice_history
)

-- ===============================
-- STEP 3: Combine Everything into a Full Entity Timeline
-- ===============================


SELECT 
    e1.invoiceid + '_' + CAST(CAST(e1.linenum AS DECIMAL(18, 0)) AS VARCHAR) + '_' + e1.dataareaid + '_DYNAMICS' AS bkey_sales_invoice_line_source,
    e1.invoiceid + '_' + CAST(CAST(e1.linenum AS DECIMAL(18, 0)) AS VARCHAR) + '_' + e1.dataareaid AS bkey_sales_invoice_line,
    e1.invoiceid + '_' + e1.dataareaid AS bkey_sales_invoice,
    'DYNAMICS' AS bkey_source,
    e1.invoiceid AS sales_invoice_id,
    e1.linenum AS sales_invoice_line_invoice_line_num,
    MAX(e1.itemid) AS sales_invoice_line_product_id,
    MAX(e1.name) AS sales_invoice_line_product_name,
    SUM(e1.qty) AS sales_invoice_line_quantity,
    SUM(e1.qty_mt) AS sales_invoice_line_quantity_mt,
    MAX(e1.salesunit) AS sales_invoice_line_uom,

    -- Invoice Line Amounts
    SUM(e1.lineamount) AS sales_invoice_line_amount_trans_cur,
    SUM(e1.lineamountmst) AS sales_invoice_line_amount_func_cur,
    SUM(e1.lineamount) / NULLIF(MAX(curr.currency_rate_average_month), 0) AS sales_invoice_line_amount_group_cur_conso_avg,
    NULL AS sales_invoice_line_amount_group_cur_oanda_eod,
    -- Invoice Line Rates
    CASE
        WHEN MAX(curr.currency_rate_average_month) IS NULL OR MAX(curr.currency_rate_average_month) = 0
            THEN 0
        ELSE 1 / MAX(curr.currency_rate_average_month)
    END AS sales_invoice_line_group_cur_conso_avg_rate,
    CASE
        WHEN MAX(e1.lineamountmst) IS NULL OR MAX(e1.lineamountmst) = 0
            THEN 0
        ELSE MAX(e1.lineamountmst) / MAX(e1.lineamount)
    END AS sales_invoice_line_func_cur_rate,
    
    e1.dataareaid AS sales_invoice_line_company,
    MAX(e1.currencycode) AS sales_invoice_line_transactional_currency_code,
    'USD' AS sales_invoice_line_group_currency_code,
    CONVERT(VARCHAR, NULL) AS sales_invoice_line_functional_currency_code,
    MAX(e2.ledgervoucher) AS sales_invoice_line_ledger_voucher,
    MAX(e2.businessunit) AS sales_invoice_line_business_unit,
    MAX(e1.itemid) as sales_invoice_line_product_global_code,
    MIN(tr.valid_from) AS valid_from,
    MAX(tr.valid_to) AS valid_to,
    CASE 
        WHEN MAX(tr.valid_to) = '2999-12-31 23:59:59.999999' THEN 1
        ELSE 0
    END AS is_current

FROM timeranges tr
LEFT JOIN customer_invoice_history e1 
    ON e1.recid = tr.recid 
    AND e1.valid_from <= tr.valid_from 
    AND COALESCE(e1.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
LEFT JOIN customer_transaction_history e2
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