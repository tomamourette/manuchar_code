-- ===============================
-- STEP 1: Extracting Historical Data (SCD2)
-- Generating valid_from and valid_to using modifieddate
-- ===============================

WITH customer_invoice_current AS (
    -- Entity details over time (SCD2)
    SELECT
        invoiceid + '_' + dataareaid AS bkey_sales_invoice,
        recid,
        invoiceid,
        dataareaid,
        invoiceaccount,
        orderaccount,
        currencycode,
        invoicedate,
        documentdate,
        duedate,
        invoiceamount,
        invoiceamountmst,
        invoicingname,
        ledgervoucher,
        vatnum,
        payment,
        paymentsched,
        customerref,
        defaultdimension,
        lgslogisticfileid,
        inventlocationid,
        printmgmtsiteid,
        salesid,
        ROW_NUMBER() OVER (
            PARTITION BY invoiceid, dataareaid
            ORDER BY createddatetime DESC
        ) AS rn
    FROM {{ ref("sv_dynamics_custinvoicejour") }}
    WHERE IsDelete IS NULL
), 

settlements_history AS (
	SELECT  
	    offsetrecid,
	    offsettransvoucher,
	    accountnum,
	    dataareaid,
	    COALESCE(SUM(settleamountcur), 0) * (-1) AS settleamountcur,
         COALESCE(SUM(settleamountmst), 0) * (-1) AS settleamountmst,
	    CAST(transdate AS DATETIME2(6)) AS valid_from,
	    CAST(LEAD(transdate) OVER (PARTITION BY offsetrecid, offsettransvoucher, accountnum, dataareaid ORDER BY transdate) AS DATETIME2(6)) AS valid_to
	FROM {{ ref("sv_dynamics_custsettlement") }}
    WHERE settleamountcur <> 0 
  	AND transtype <> 24 
  	GROUP BY 
	    offsetrecid,
	    offsettransvoucher,
	    accountnum,
	    dataareaid,
	    transdate
),

customer_invoice_history AS (
	SELECT	
		cust.bkey_sales_invoice,
		cust.recid,
        cust.invoiceid,
        cust.invoiceaccount,
        cust.orderaccount,
        cust.dataareaid,
        cust.currencycode,
        cust.invoicedate,
        cust.documentdate,
        cust.duedate,
        cust.invoiceamount,
        cust.invoiceamountmst,
        cust.invoicingname,
        cust.ledgervoucher,
        cust.vatnum,
        cust.payment,
        cust.paymentsched,
        cust.customerref,
        cust.defaultdimension,
        cust.lgslogisticfileid,
        cust.inventlocationid,
        cust.printmgmtsiteid,
        cust.salesid,
        custtable.lineofbusinessid,
        trans.recid AS trans_recid,
        trans.voucher,
        trans.closed,
        trans.paymreference,
        trans.paymtermid,
        trans.txt,
        sett.settleamountcur,
        sett.settleamountmst,
        COALESCE(sett.valid_from, CAST(cust.invoicedate AS DATETIME2(6))) AS valid_from,
        sett.valid_to AS valid_to
    FROM customer_invoice_current cust
    LEFT JOIN {{ ref("sv_dynamics_custtrans") }} trans
	    ON trans.accountnum = cust.invoiceaccount
	    AND trans.voucher = cust.ledgervoucher
	    AND trans.transdate = cust.invoicedate
	    AND trans.invoice = cust.invoiceid
    LEFT JOIN settlements_history sett
	    ON sett.accountnum = cust.invoiceaccount
	    AND sett.offsettransvoucher = cust.ledgervoucher
	    AND sett.dataareaid = cust.dataareaid
	    AND sett.offsetrecid = trans.recid
    LEFT JOIN {{ ref("sv_dynamics_custtable") }} custtable
        ON custtable.accountnum = cust.invoiceaccount
        AND custtable.dataareaid = cust.dataareaid
    WHERE cust.rn = 1 -- take only lastest value of bkey_sales_invoice
),

general_journal AS (
	SELECT 
        ledgeraccount,
        subledgervoucher
    FROM {{ ref("sv_dynamics_generaljournalentry") }} gj 
    LEFT JOIN {{ ref("sv_dynamics_generaljournalaccountentry") }} gja 
        ON gja.generaljournalentry = gj.recid 
),

opentransactions AS (
    SELECT
        refrecid,
        accountnum,
        dataareaid,
        partition,
        MAX(duedate) AS opentrans_duedate
    FROM {{ ref("sv_dynamics_custtransopen") }}
    GROUP BY 
        refrecid,
        accountnum,
        dataareaid,
        partition
),


dimensions AS (
    SELECT
        recid,
        order_value,
        procenvalue,
        coscenvalue,
        countryofdestinationvalue
    FROM {{ ref("sv_dynamics_dimensionattributevalueset") }}
),

salestable AS (
	SELECT 
		salesid,
		shippingdateconfirmed 
	FROM {{ ref("sv_dynamics_salestable") }}
	WHERE shippingdateconfirmed IS NOT NULL
),
-- ===============================
-- STEP 2: Generate Time Ranges for SCD2
-- ===============================

customer_timeranges AS (
    SELECT 
        bkey_sales_invoice,
        CAST(valid_from AS DATETIME2(6)) AS valid_from,
        CAST(LEAD(valid_from) OVER (PARTITION BY bkey_sales_invoice ORDER BY valid_from) AS DATETIME2(6)) AS valid_to
    FROM customer_invoice_history
)

-- ===============================
-- STEP 3: Combine Everything into a Full Entity Timeline
-- ===============================
SELECT 
    tr.bkey_sales_invoice + '_DYNAMICS' AS bkey_sales_invoice_source,
    tr.bkey_sales_invoice AS bkey_sales_invoice,
    'DYNAMICS' AS bkey_source,
    MAX(e1.invoiceid) AS sales_invoice_id,
    MAX(e1.invoiceaccount) AS sales_invoice_customer_id,
    MAX(e1.orderaccount) AS sales_invoice_order_customer_id,
    MAX(e1.dataareaid) AS sales_invoice_company,
    MAX(e1.currencycode) AS sales_invoice_transactional_currency_code,
    'USD' AS sales_invoice_group_currency_code,
    CONVERT(VARCHAR, NULL) AS sales_invoice_functional_currency_code,
    MAX(e1.invoicedate) AS sales_invoice_date,
    MAX(e1.documentdate) AS sales_invoice_document_date,
    COALESCE(MAX(ot.opentrans_duedate), MAX(e1.duedate)) AS sales_invoice_due_date, 
    CAST(MAX(DATEADD(DAY, 7 - DATEPART(WEEKDAY, COALESCE(tr.valid_from, e1.invoicedate)) + 1, CAST(COALESCE(tr.valid_from, e1.invoicedate) AS DATE))) AS DATETIME2(6)) AS sales_invoice_closure_date,

    -- Invoice Amounts
    MAX(e1.invoiceamount)  AS sales_invoice_amount_trans_cur,
    MAX(e1.invoiceamountmst) AS sales_invoice_amount_func_cur,
    MAX(e1.invoiceamount) / MAX(curr.currency_rate_closing_rate) AS sales_invoice_amount_group_cur_conso_eom,
    MAX(e1.invoiceamount) / MAX(curr.currency_rate_average_month) AS sales_invoice_amount_group_cur_conso_avg,
    NULL AS sales_invoice_amount_group_cur_oanda_eod,
    -- Open Amounts
    MAX(e1.invoiceamount) - MAX(e1.settleamountcur) AS sales_invoice_open_amount_trans_cur,
    MAX(e1.invoiceamountmst) - MAX(e1.settleamountmst) AS sales_invoice_open_amount_func_cur,
    MAX(e1.invoiceamount) - MAX(e1.settleamountcur) / MAX(curr.currency_rate_closing_rate) AS sales_invoice_open_amount_group_cur_conso_eom,
    MAX(e1.invoiceamount) - MAX(e1.settleamountcur) / MAX(curr.currency_rate_average_month) AS sales_invoice_open_amount_group_cur_conso_avg,
    NULL AS sales_invoice_open_amount_group_cur_oanda_eod,
    -- Settled Amounts
    MAX(e1.settleamountcur) AS sales_invoice_settled_amount_trans_cur,
    MAX(e1.settleamountmst) AS sales_invoice_settled_amount_func_cur,
    MAX(e1.settleamountcur) / MAX(curr.currency_rate_closing_rate) AS sales_invoice_settled_amount_group_cur_conso_eom,
    MAX(e1.settleamountcur) / MAX(curr.currency_rate_average_month) AS sales_invoice_settled_amount_group_cur_conso_avg,
    NULL AS sales_invoice_settled_amount_group_cur_oanda_eod,
    -- Currency Rates
    CASE
        WHEN MAX(curr.currency_rate_closing_rate) IS NULL OR MAX(curr.currency_rate_closing_rate) = 0
            THEN 0
        ELSE 1 / MAX(curr.currency_rate_closing_rate)
    END AS sales_invoice_group_cur_conso_eom_rate,
    CASE
        WHEN MAX(curr.currency_rate_average_month) IS NULL OR MAX(curr.currency_rate_average_month) = 0
            THEN 0
        ELSE 1 / MAX(curr.currency_rate_average_month)
    END AS sales_invoice_group_cur_conso_avg_rate,
    CASE
        WHEN MAX(e1.invoiceamountmst) IS NULL OR MAX(e1.invoiceamountmst) = 0
            THEN 0
        ELSE MAX(e1.invoiceamountmst) / MAX(e1.invoiceamount)
    END AS sales_invoice_func_cur_rate,

    MAX(e1.invoicingname) AS sales_invoice_name,
    MAX(e1.vatnum) AS sales_invoice_customer_vat,
    MAX(dim.countryofdestinationvalue) AS sales_invoice_destination_country,
    MAX(e1.customerref) AS sales_invoice_external_reference,
    MAX(e1.paymentsched) AS sales_invoice_payment_schedule,
    MAX(e1.ledgervoucher) AS sales_invoice_ledger_voucher,
    CASE 
        WHEN e1.dataareaid = 'mmex' THEN MAX(e1.salesid)
        ELSE MAX(dim.order_value)
    END AS sales_invoice_order_value,
    --MAX(dim.order_value) AS sales_invoice_order_value,
    MAX(e1.payment) AS sales_invoice_payment,
    MAX(e1.txt) AS sales_invoice_txt,
    MAX(NULLIF(e1.closed, '1900-01-01 00:00:00.000')) AS sales_invoice_closed,
    MAX(e1.paymreference) AS sales_invoice_payment_reference,
    MAX(e1.paymtermid) AS sales_invoice_paymtermid,
    MAX(dim.procenvalue) AS sales_invoice_procenvalue,
    MAX(dim.coscenvalue) AS sales_invoice_coscenvalue,
    MAX(e1.lgslogisticfileid) AS sales_invoice_logistic_id,
    MAX(e1.voucher) AS sales_invoice_accrual_voucher,
    MAX(gj.ledgeraccount) AS sales_invoice_ledger_account,
    MAX(
        CASE 
            WHEN dim.procenvalue LIKE '%\_I%' ESCAPE '\' THEN UPPER(LEFT(dim.procenvalue, 3))
            WHEN e1.lineofbusinessid IS NOT NULL THEN UPPER(e1.lineofbusinessid)
            ELSE NULL
        END
    ) AS sales_invoice_industry_code,
    MAX(inventlocationid) AS sales_invoice_invent_location,
    MAX(printmgmtsiteid) AS sales_invoice_site_id,
    MAX(shippingdateconfirmed) AS sales_invoice_shipping_date,
    tr.valid_from,
    tr.valid_to,
    CASE 
        WHEN MAX(tr.valid_to) IS NULL THEN 1 
        ELSE 0
    END AS is_current

FROM customer_timeranges tr
LEFT JOIN customer_invoice_history e1 
    ON e1.bkey_sales_invoice = tr.bkey_sales_invoice
    AND (e1.valid_from <= tr.valid_from OR e1.valid_from IS NULL)
    AND (e1.valid_to > tr.valid_from OR e1.valid_to IS NULL)  
    

LEFT JOIN general_journal gj
    ON e1.voucher = gj.subledgervoucher 

LEFT JOIN opentransactions ot
    ON e1.dataareaid = ot.dataareaid
    AND e1.invoiceaccount = ot.accountnum
    AND e1.trans_recid = ot.refrecid

LEFT JOIN dimensions dim
    ON dim.recid = e1.defaultdimension

LEFT JOIN salestable st 
    ON st.salesid=e1.salesid

LEFT JOIN {{ ref("currency_rate_mona") }} curr
    ON curr.currency_rate_currency_code = e1.currencycode
    AND FORMAT(COALESCE(tr.valid_from, e1.invoicedate), 'yyyyMM') = FORMAT(curr.currency_rate_closing_date, 'yyyyMM')

GROUP BY 
    tr.bkey_sales_invoice,
    e1.dataareaid,
    tr.valid_from,
    tr.valid_to