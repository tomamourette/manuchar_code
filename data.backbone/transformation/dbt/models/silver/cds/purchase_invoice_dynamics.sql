-- ===============================
-- STEP 1: Extracting Historical Data (SCD2)
-- Generating valid_from and valid_to using modifieddate
-- ===============================

WITH vendor_invoice_current AS (
    SELECT 
        -- Entity details over time (SCD2)
        MAX(vij.recid) AS recid,
        vij.invoiceid + '_' + vij.dataareaid AS bkey_purchase_invoice,
        vij.invoiceid,
        MAX(vij.invoiceaccount) AS invoiceaccount,
        MAX(vij.orderaccount) AS orderaccount,
        vij.dataareaid,
        MAX(vij.currencycode) AS currencycode,
        MAX(vij.invoicedate) AS invoicedate,
        MAX(vij.documentdate) AS documentdate,
        MAX(vij.duedate) AS duedate,
        SUM(vij.invoiceamount) AS invoiceamount,
        SUM(vij.invoiceamountmst) AS invoiceamountmst,
        MAX(vij.ledgervoucher) AS ledgervoucher,
        MAX(vij.vatnum) AS vatnum,
        MAX(vij.payment) AS payment,
        MAX(vij.paymentsched) AS paymentsched,
        MAX(vij.lgslogisticfileid) AS lgslogisticfileid,
        SUM(vij.sumtax) AS sumtax,
        MAX(vij.purchid) AS purchid,
        MAX(vij.reportingcurrencyexchangerate) AS reportingcurrencyexchangerate,
        MAX(vij.exchrate) AS exchrate,
        SUM(vij.qty) AS qty,
        MAX(vij.internalinvoiceid) AS internalinvoiceid,
        MAX(vij.defaultdimension) AS defaultdimension,
        MAX(vij.description) AS [description]
    FROM {{ ref('sv_dynamics_vendinvoicejour')}} vij
    WHERE vij.IsDelete IS NULL
    GROUP BY
        vij.invoiceid,
        vij.dataareaid
),

settlements_history AS (
    SELECT
	    offsetrecid,
	    offsettransvoucher,
	    accountnum, 
	    dataareaid, 
	    COALESCE(SUM(settleamountcur), 0) AS settleamountcur,
        COALESCE(SUM(settleamountmst), 0) AS settleamountmst,
        CAST(transdate AS DATETIME2(6)) AS valid_from,
	    CAST(LEAD(transdate) OVER (PARTITION BY offsetrecid, offsettransvoucher, accountnum, dataareaid ORDER BY transdate) AS DATETIME2(6)) AS valid_to
    FROM {{ ref('sv_dynamics_vendsettlement')}}
    WHERE settleamountcur <> 0
    AND transtype <> 24
    GROUP BY 
	    offsetrecid,
    	offsettransvoucher,
    	accountnum, 
    	dataareaid,
        transdate
),

vendor_invoice_history AS (
    SELECT 
        vic.bkey_purchase_invoice,
        vic.recid,
        vic.invoiceid,
        vic.invoiceaccount,
        vic.orderaccount,
        vic.dataareaid,
		vic.currencycode,
        vic.invoicedate,
        vic.documentdate,
        vic.duedate,
        vic.invoiceamount,
        vic.invoiceamountmst,
        vic.ledgervoucher,
        vic.vatnum,
        vic.payment,
        vic.paymentsched,
        vic.lgslogisticfileid,
        vic.sumtax,
        vic.purchid,
        vic.reportingcurrencyexchangerate,
        vic.exchrate,
        vic.qty,
        vic.internalinvoiceid,
		vic.defaultdimension,
        trans.duedate AS vendtrans_duedate,
        trans.paymtermid,
        trans.closed,
        trans.accountnum,
        CAST(stm.settleamountcur AS DECIMAL(18,2)) AS settleamountcur,
        CAST(stm.settleamountmst AS DECIMAL(18,2)) AS settleamountmst,
        vic.description,
        COALESCE(stm.valid_from, CAST(vic.invoicedate AS DATETIME2(6))) AS valid_from,
        stm.valid_to AS valid_to
    FROM vendor_invoice_current vic
	LEFT JOIN {{ ref("sv_dynamics_vendtrans") }} trans
	    ON trans.accountnum = vic.invoiceaccount
	    AND trans.voucher = vic.ledgervoucher
	    AND trans.transdate = vic.invoicedate
	    AND trans.invoice = vic.invoiceid
	LEFT JOIN settlements_history AS stm
		ON vic.invoiceaccount = stm.accountnum
		AND trans.recid = stm.offsetrecid
		AND vic.ledgervoucher = stm.offsettransvoucher
		AND vic.dataareaid = stm.dataareaid
),

dimensions AS (
	SELECT
		recid,
		order_value,
		procenvalue,
		coscenvalue,
		countryofdestinationvalue
	FROM {{ ref('sv_dynamics_dimensionattributevalueset')}}
),

-- ===============================
-- STEP 2: Generate Time Ranges for SCD2
-- Consolidating timestamps separately for customer and vendor invoices
-- ===============================

vendor_timeranges AS (
    SELECT 
        bkey_purchase_invoice,
        CAST(valid_from AS DATETIME2(6)) AS valid_from,
        CAST(LEAD(valid_from) OVER (PARTITION BY bkey_purchase_invoice ORDER BY valid_from) AS DATETIME2(6)) AS valid_to
    FROM vendor_invoice_history
)

-- ===============================
-- STEP 3: Combine Everything into a Full Entity Timeline
-- - SCD2 (history tables) are joined on recid + valid time range.
-- ===============================
SELECT 
    tr.bkey_purchase_invoice + '_DYNAMICS' AS bkey_purchase_invoice_source,
	tr.bkey_purchase_invoice,
	'DYNAMICS' AS bkey_source,
	MAX(e1.invoiceid) AS purchase_invoice_id,
	MAX(e1.invoiceaccount) AS purchase_invoice_supplier_id,
	MAX(e1.orderaccount) AS purchase_invoice_order_supplier_id,
    MAX(e1.dataareaid) AS purchase_invoice_company,
    CAST(MAX(DATEADD(DAY, 7 - DATEPART(WEEKDAY, COALESCE(tr.valid_from, e1.invoicedate)) + 1, CAST(COALESCE(tr.valid_from, e1.invoicedate) AS DATE))) AS DATETIME2(6)) AS purchase_invoice_closure_date,
    MAX(e1.currencycode) AS purchase_invoice_transactional_currency_code,
    'USD' AS purchase_invoice_group_currency_code,
    CONVERT(VARCHAR, NULL) AS purchase_invoice_functional_currency_code,
    MAX(e1.invoicedate) AS purchase_invoice_date,
    MAX(e1.documentdate) AS purchase_invoice_document_date,
    COALESCE(MAX(e1.vendtrans_duedate), MAX(e1.duedate)) AS purchase_invoice_due_date, 
    
    -- Invoice Amounts
    MAX(e1.invoiceamount)  AS purchase_invoice_amount_trans_cur,
    MAX(e1.invoiceamountmst) AS purchase_invoice_amount_func_cur,
    MAX(e1.invoiceamount) / MAX(curr.currency_rate_closing_rate) AS purchase_invoice_amount_group_cur_conso_eom,
    MAX(e1.invoiceamount) / MAX(curr.currency_rate_average_month) AS purchase_invoice_amount_group_cur_conso_avg,
    NULL AS purchase_invoice_amount_group_cur_oanda_eod,
    -- Open Amounts
    MAX(e1.invoiceamount) - MAX(e1.settleamountcur) AS purchase_invoice_open_amount_trans_cur,
    MAX(e1.invoiceamountmst) - MAX(e1.settleamountmst) AS purchase_invoice_open_amount_func_cur,
    MAX(e1.invoiceamount) - MAX(e1.settleamountcur) / MAX(curr.currency_rate_closing_rate) AS purchase_invoice_open_amount_group_cur_conso_eom,
    MAX(e1.invoiceamount) - MAX(e1.settleamountcur) / MAX(curr.currency_rate_average_month) AS purchase_invoice_open_amount_group_cur_conso_avg,
    NULL AS purchase_invoice_open_amount_group_cur_oanda_eod,
    -- Settled Amounts
    MAX(e1.settleamountcur) AS purchase_invoice_settled_amount_trans_cur,
    MAX(e1.settleamountmst) AS purchase_invoice_settled_amount_func_cur,
    MAX(e1.settleamountcur) / MAX(curr.currency_rate_closing_rate) AS purchase_invoice_settled_amount_group_cur_conso_eom,
    MAX(e1.settleamountcur) / MAX(curr.currency_rate_average_month) AS purchase_invoice_settled_amount_group_cur_conso_avg,
    NULL AS purchase_invoice_settled_amount_group_cur_oanda_eod,
    -- Currency Rates
    CASE
        WHEN MAX(curr.currency_rate_closing_rate) IS NULL OR MAX(curr.currency_rate_closing_rate) = 0
            THEN 0
        ELSE 1 / MAX(curr.currency_rate_closing_rate)
    END AS purchase_invoice_group_cur_conso_eom_rate,
    CASE
        WHEN MAX(curr.currency_rate_average_month) IS NULL OR MAX(curr.currency_rate_average_month) = 0
            THEN 0
        ELSE 1 / MAX(curr.currency_rate_average_month)
    END AS purchase_invoice_group_cur_conso_avg_rate,
    CASE
        WHEN MAX(e1.invoiceamountmst) IS NULL OR MAX(e1.invoiceamountmst) = 0
            THEN 0
        ELSE MAX(e1.invoiceamountmst) / MAX(e1.invoiceamount)
    END AS purchase_invoice_func_cur_rate,

    MAX(e1.ledgervoucher) AS purchase_invoice_ledger_voucher,
    MAX(e1.vatnum) AS purchase_invoice_legal_number,
    COALESCE(MAX(e1.paymtermid), MAX(e1.payment)) AS purchase_invoice_payment,
    MAX(e1.paymentsched) AS purchase_invoice_payment_schedule,
    MAX(e1.lgslogisticfileid) AS purchase_invoice_logistic_file_id,
    MAX(e1.sumtax) AS purchase_invoice_tax_amount,
    MAX(e1.purchid) AS purchase_invoice_purchase_id,
    MAX(e1.reportingcurrencyexchangerate) AS purchase_invoice_reporting_currency_exchange_rate,
    MAX(e1.exchrate) AS purchase_invoice_exchange_rate,
    MAX(e1.qty) AS purchase_invoice_quantity,
    MAX(e1.internalinvoiceid) AS purchase_invoice_internal_invoice_id,
    MAX(e1.accountnum) AS purchase_invoice_account_number,
    MAX(CASE WHEN dim.order_value IS NULL THEN 
			(CASE
				WHEN SUBSTRING(e1.description, 5, 1) = '/' AND SUBSTRING(e1.description, 10, 1) = '/' 
					THEN e1.description
				ELSE ''
			END)
			ELSE dim.order_value
		END) AS purchase_invoice_file_number,
    MAX(LEFT(dim.procenvalue, 3)) AS purchase_invoice_industry_code,
    MAX(NULLIF(e1.closed, '1900-01-01 00:00:00.000')) AS purchase_invoice_closed,
    MIN(tr.valid_from) AS valid_from,
    MAX(tr.valid_to) AS valid_to,
    CASE 
        WHEN MAX(tr.valid_to) IS NULL THEN 1 
        ELSE 0
    END AS is_current
FROM vendor_timeranges tr
LEFT JOIN vendor_invoice_history e1
	ON e1.bkey_purchase_invoice = tr.bkey_purchase_invoice
	AND (e1.valid_from <= tr.valid_from
	 OR e1.valid_from IS NULL)
	AND COALESCE(e1.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from

LEFT JOIN dimensions dim
	ON dim.recid = e1.defaultdimension

LEFT JOIN {{ ref("currency_rate_mona") }} curr
    ON curr.currency_rate_currency_code = e1.currencycode
    AND FORMAT(COALESCE(tr.valid_from, e1.invoicedate), 'yyyyMM') = FORMAT(curr.currency_rate_closing_date, 'yyyyMM')

GROUP BY
	tr.bkey_purchase_invoice,
	tr.valid_from,
	tr.valid_to