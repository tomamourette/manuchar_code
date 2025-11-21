-- ===============================
-- STEP 1: Extracting Historical Data (SCD2)
-- Generating valid_from and valid_to using modifieddate
-- ===============================

WITH purchase_invoice_line_cogs_history AS (
	SELECT
		ROW_NUMBER() OVER (ORDER BY pur.purchid, purl.linenumber, vij.invoiceid) AS tkey_purchase_invoice_line_cogs,
		pur.purchid + '_' + ISNULL(CONVERT(VARCHAR, purl.linenumber), '') + '_' + ISNULL(vij.invoiceid, '') + '_DYNAMICS' AS bkey_purchase_invoice_line_cogs_source,
		pur.purchid + '_' + ISNULL(CONVERT(VARCHAR, purl.linenumber), '') + '_' + ISNULL(vij.invoiceid, '') AS bkey_purchase_invoice_line_cogs,
		'DYNAMICS' AS bkey_source,
		'MST' AS bkey_flow,
		purl.lgslogisticfileid AS logisticfileid,
		pur.paymentsched,
		pur.payment,
		pur.dctdestination,
		pur.ecscontractstatus,
		pur.rsktradingbookid,
		pur.createddatetime,
		pur.purchid,
		purl.linenumber,
		purl.itemid,
		purl.dlvterm,
		pur.dataareaid,
		pur.orderaccount,
		pur.requester,
		pur.rsktrader,
		pur.workerpurchplacer,
		CONVERT(VARCHAR, pur.purchstatus) AS purchstatus,
		pur.ccsclosingstatus,
		pur.ecstradetype,
		pur.purchasetype,
		pur.accountingdate,
		vij.internalinvoiceid,
		vij.invoiceid,
		vij.invoiceaccount,
		NULL AS origincountryid,
		NULL AS destinationcountryid,
		SUM(CASE
				WHEN dar.report = 'Adjusted COGS'
					THEN gjae.reportingcurrencyamount
				ELSE 0
			END) AS purchase_invoice_line_cogs_adjusted_cogs_functional,
		SUM(CASE
				WHEN dar.report = 'Adjusted COGS'
					THEN gjae.transactioncurrencyamount
				ELSE 0
			END) AS purchase_invoice_line_cogs_adjusted_cogs_transactional,
		SUM(CASE
				WHEN dar.report = 'Adjusted COGS'
					THEN gjae.transactioncurrencyamount / NULLIF(curr.currency_rate_average_month, 0)
				ELSE 0
			END) AS purchase_invoice_line_cogs_adjusted_cogs_group_conso_avg,
		SUM(CASE
				WHEN dar.report = 'COGS1 Purchase Amount'
					THEN gjae.reportingcurrencyamount
				ELSE 0
			END) AS purchase_invoice_line_cogs_cogs1_purchase_amount_functional,
		SUM(CASE
				WHEN dar.report = 'COGS1 Purchase Amount'
					THEN gjae.transactioncurrencyamount
				ELSE 0
			END) AS purchase_invoice_line_cogs_cogs1_purchase_amount_transactional,
		SUM(CASE
				WHEN dar.report = 'COGS1 Purchase Amount'
					THEN gjae.transactioncurrencyamount / NULLIF(curr.currency_rate_average_month, 0)
				ELSE 0
			END) AS purchase_invoice_line_cogs_cogs1_purchase_amount_group_conso_avg,
		SUM(CASE
				WHEN dar.report = 'COGS1 Freight Amount'
					THEN gjae.reportingcurrencyamount
				ELSE 0
			END) AS purchase_invoice_line_cogs_cogs1_freight_amount_functional,
		SUM(CASE
				WHEN dar.report = 'COGS1 Freight Amount'
					THEN gjae.transactioncurrencyamount
				ELSE 0
			END) AS purchase_invoice_line_cogs_cogs1_freight_amount_transactional,
		SUM(CASE
				WHEN dar.report = 'COGS1 Freight Amount'
					THEN gjae.transactioncurrencyamount / NULLIF(curr.currency_rate_average_month, 0)
				ELSE 0
			END) AS purchase_invoice_line_cogs_cogs1_freight_amount_group_conso_avg,
		SUM(CASE
				WHEN dar.report = 'COGS1 Other Amount'
					THEN gjae.reportingcurrencyamount
				ELSE 0
			END) AS purchase_invoice_line_cogs_cogs1_other_amount_functional,
		SUM(CASE
				WHEN dar.report = 'COGS1 Other Amount'
					THEN gjae.transactioncurrencyamount
				ELSE 0
			END) AS purchase_invoice_line_cogs_cogs1_other_amount_transactional,
		SUM(CASE
				WHEN dar.report = 'COGS1 Other Amount'
					THEN gjae.transactioncurrencyamount / NULLIF(curr.currency_rate_average_month, 0)
				ELSE 0
			END) AS purchase_invoice_line_cogs_cogs1_other_amount_group_conso_avg,
		CAST(davc.modifieddatetime AS DATETIME2(6)) AS valid_from,
		CAST(LEAD(davc.modifieddatetime) OVER (PARTITION BY CONCAT(pur.purchid, '_', CONVERT(VARCHAR, purl.linenumber), '_', ISNULL(vij.invoiceid, '')) ORDER BY davc.modifieddatetime) AS DATETIME2(6)) AS valid_to
	FROM {{ ref('sv_dynamics_purchtable')}} pur
	LEFT JOIN {{ ref('sv_dynamics_purchline')}} purl
		ON pur.purchid = purl.purchid
	LEFT JOIN {{ ref('sv_dynamics_vendinvoicejour')}} vij
		ON pur.purchid = vij.purchid
	LEFT JOIN {{ ref('sv_dynamics_vendtrans')}} vt
		ON vij.ledgervoucher = vt.voucher
		AND vij.dataareaid = vt.dataareaid
	LEFT JOIN {{ ref('sv_dynamics_vendinvoicetrans')}} vit
		ON vij.purchid = vit.purchid
	LEFT JOIN {{ ref('sv_dynamics_generaljournalentry')}} gje
		ON vt.voucher = gje.subledgervoucher
		AND vt.dataareaid = gje.subledgervoucherdataareaid
	LEFT JOIN {{ ref('sv_dynamics_generaljournalaccountentry')}} gjae
		ON gje.recid = gjae.generaljournalentry
	LEFT JOIN {{ ref('sv_dynamics_dimensionattributevaluecombination')}} davc
		ON gjae.ledgerdimension = davc.recid
	INNER JOIN {{ ref('sv_dbb_lakehouse_d365accounts_report')}} dar
		ON davc.mainaccountvalue =	CASE
										WHEN LOWER(gje.subledgervoucherdataareaid) IN ('mits', 'meur', 'ldint', 'exp', 'bau',
																						'mwoo', 'mppa', 'ui', 'ptc', 'mst', 'mnv') 
											THEN dar.[d365_bcoa_hq_maneur]
										ELSE dar.[d365_affiliates_e_g_pakistan]
									END
	LEFT JOIN {{ ref('currency_rate_mona')}} curr
		ON vij.currencycode = curr.currency_rate_currency_code
		AND	FORMAT(vij.invoicedate, 'yyyyMM') = FORMAT(curr.currency_rate_closing_date, 'yyyyMM')
	GROUP BY
		pur.paymentsched,
		pur.payment,
		pur.dctdestination,
		pur.ecscontractstatus,
		pur.rsktradingbookid,
		pur.createddatetime,
		pur.purchid,
		purl.linenumber,
		purl.itemid,
		purl.dlvterm,
		purl.lgslogisticfileid,
		pur.dataareaid,
		pur.orderaccount,
		pur.requester,
		pur.rsktrader,
		pur.workerpurchplacer,
		pur.purchstatus,
		pur.ccsclosingstatus,
		pur.ecstradetype,
		pur.purchasetype,
		pur.accountingdate,
		vij.internalinvoiceid,
		vij.invoiceid,
		vij.invoiceaccount,
		davc.modifieddatetime
),

-- ===============================
-- STEP 2: Generate Time Ranges for SCD2
-- Consolidating timestamps separately for customer and vendor invoices
-- ===============================

purchase_invoice_line_cogs_timeranges AS (
    SELECT 
        bkey_purchase_invoice_line_cogs,
        CAST(valid_from AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(valid_from) OVER (PARTITION BY bkey_purchase_invoice_line_cogs ORDER BY valid_from), '2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM purchase_invoice_line_cogs_history
)

SELECT
    e1.tkey_purchase_invoice_line_cogs,
    e1.bkey_purchase_invoice_line_cogs_source,
    tr.bkey_purchase_invoice_line_cogs,
    e1.bkey_source,
	e1.bkey_flow,
	e1.logisticfileid AS purchase_invoice_line_cogs_file_number,
    e1.paymentsched AS purchase_invoice_line_cogs_payment_schedule,
    e1.payment AS purchase_invoice_line_cogs_payment,
    e1.dctdestination AS purchase_invoice_line_cogs_dct_destination,
    e1.ecscontractstatus AS purchase_invoice_line_cogs_ecs_contract_status,
    e1.rsktradingbookid AS purchase_invoice_line_cogs_risk_trading_book_id,
    e1.createddatetime AS purchase_invoice_line_cogs_created_date_time,
    e1.dataareaid AS purchase_invoice_line_cogs_company,
    e1.orderaccount AS purchase_invoice_line_cogs_order_account,
    e1.requester AS purchase_invoice_line_cogs_requester,
    e1.rsktrader AS purchase_invoice_line_cogs_risk_trader,
    e1.workerpurchplacer AS purchase_invoice_line_cogs_worker_purchase_placer,
    e1.purchstatus AS purchase_invoice_line_cogs_purchase_state,
    e1.ccsclosingstatus AS purchase_invoice_line_cogs_ccs_closing_status,
    e1.ecstradetype AS purchase_invoice_line_cogs_ecs_trade_type,
    e1.purchasetype AS purchase_invoice_line_cogs_purchase_type,
    e1.invoiceaccount AS purchase_invoice_line_cogs_invoice_account,
    e1.accountingdate AS purchase_invoice_line_cogs_accounting_date,
    e1.internalinvoiceid AS purchase_invoice_line_cogs_internal_invoice_id,
    e1.itemid AS purchase_invoice_line_cogs_product,
	e1.purchid AS purchase_invoice_line_cogs_purchase_id,
    e1.linenumber AS purchase_invoice_line_cogs_line_number,
    e1.dlvterm AS purchase_invoice_line_cogs_incoterm,
    e1.origincountryid AS purchase_invoice_line_cogs_origin_country,
    e1.destinationcountryid AS purchase_invoice_line_cogs_destination_country,
	e1.purchase_invoice_line_cogs_adjusted_cogs_functional,
	e1.purchase_invoice_line_cogs_adjusted_cogs_transactional,
	e1.purchase_invoice_line_cogs_adjusted_cogs_group_conso_avg,
	e1.purchase_invoice_line_cogs_cogs1_purchase_amount_functional,
	e1.purchase_invoice_line_cogs_cogs1_purchase_amount_transactional,
	e1.purchase_invoice_line_cogs_cogs1_purchase_amount_group_conso_avg,
	e1.purchase_invoice_line_cogs_cogs1_freight_amount_functional,
	e1.purchase_invoice_line_cogs_cogs1_freight_amount_transactional,
	e1.purchase_invoice_line_cogs_cogs1_freight_amount_group_conso_avg,
	e1.purchase_invoice_line_cogs_cogs1_other_amount_functional,
	e1.purchase_invoice_line_cogs_cogs1_other_amount_transactional,
	e1.purchase_invoice_line_cogs_cogs1_other_amount_group_conso_avg,
    tr.valid_from,
    tr.valid_to,
    CASE 
        WHEN tr.valid_to = '2999-12-31 23:59:59.999999' THEN 1 
        ELSE 0
    END AS is_current
FROM purchase_invoice_line_cogs_timeranges tr
LEFT JOIN purchase_invoice_line_cogs_history e1
    ON e1.bkey_purchase_invoice_line_cogs = tr.bkey_purchase_invoice_line_cogs
    AND e1.valid_from <= tr.valid_from 
    AND COALESCE(e1.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from