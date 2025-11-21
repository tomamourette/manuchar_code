WITH purchase_invoice_line_cogs_history AS (
	SELECT
		ROW_NUMBER() OVER (ORDER BY davc.order_value, vij.invoiceid, vij.internalinvoiceid) AS tkey_purchase_invoice_line_cogs,
		ISNULL(davc.order_value, '') + '_' + ISNULL(CONVERT(VARCHAR, pur.purchaseOrder_id), '') + '_' + ISNULL(vij.invoiceid, '') + '_' + ISNULL(vij.internalinvoiceid, '') + '_' + ISNULL(prd.ProdName, '') + '_DYNAMICS' AS bkey_purchase_invoice_line_cogs_source,
		ISNULL(davc.order_value, '') + '_' + ISNULL(CONVERT(VARCHAR, pur.purchaseOrder_id), '') + '_' + ISNULL(vij.invoiceid, '') + '_' + ISNULL(vij.internalinvoiceid, '') + '_' + ISNULL(prd.ProdName, '') AS bkey_purchase_invoice_line_cogs,
		'DYNAMICS' AS bkey_source,
		'MTM' AS bkey_flow,
		davc.order_value,
		pur.paymentTerms,
		CONVERT(VARCHAR, NULL) AS payment,
		CONVERT(VARCHAR, NULL) AS dctdestination,
		CONVERT(VARCHAR, NULL) AS ecscontractstatus,
		CONVERT(VARCHAR, NULL) AS rsktradingbookid,
		CONVERT(DATETIME2(6), NULL) AS createddatetime,
		CONVERT(VARCHAR, pur.purchaseOrder_id) AS purchaseOrder_id,
		NULL AS linenumber,
		prd.ProdName,
		pur.incoterm,
		vij.dataareaid,
		vij.invoiceaccount AS orderaccount,
		NULL AS requester,
		NULL AS rsktrader,
		NULL AS workerpurchplacer,
		CONVERT(VARCHAR, fil.fileStatus) AS fileStatus,
		NULL AS ccsclosingstatus,
		NULL AS ecstradetype,
		NULL AS purchasetype,
		CONVERT(DATETIME2(6), NULL) AS accountingdate,
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
		CAST(COALESCE(pur.latestDelDate, vij.modifieddatetime) AS DATETIME2(6)) AS valid_from,
        CAST(ISNULL(LEAD(COALESCE(pur.latestDelDate, vij.modifieddatetime, '2999-12-31 23:59:59.999999')) OVER (PARTITION BY davc.order_value, pur.purchaseOrder_id, vij.invoiceid, vij.internalinvoiceid, prd.ProdName ORDER BY COALESCE(pur.latestDelDate, vij.modifieddatetime, '2999-12-31 23:59:59.999999')), '2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
	FROM {{ ref('sv_dynamics_dimensionattributevaluecombination')}} davc
	LEFT JOIN {{ ref('sv_mtm_fil')}} fil
		ON fil.fileNumber = davc.order_value
	LEFT JOIN {{ ref('sv_mtm_pd')}} pur
		ON fil.[file_id] = pur.[file_id]
	LEFT JOIN {{ ref('sv_mtm_filgrid')}} flg
		ON fil.[file_id] = flg.[file_id]
	LEFT JOIN {{ ref('sv_mtm_dim_products')}} prd
		ON flg.product_id = prd.product_id
	LEFT JOIN {{ ref('sv_dynamics_generaljournalaccountentry')}} gjae
		ON davc.recid = gjae.ledgerdimension
	LEFT JOIN {{ ref('sv_dynamics_generaljournalentry')}} gje
		ON gjae.generaljournalentry = gje.recid
	LEFT JOIN {{ ref('sv_dynamics_vendinvoicejour')}} vij
		ON gje.subledgervoucher = vij.ledgervoucher
		AND lower(gje.subledgervoucherdataareaid) = lower(vij.dataareaid)
	INNER JOIN {{ ref('sv_dbb_lakehouse_d365accounts_report')}} dar
		ON davc.mainaccountvalue = CASE
									   WHEN gje.subledgervoucherdataareaid IN ('mits', 'meur', 'ldint', 'exp', 'bau',
																				'mwoo', 'mppa', 'ui', 'ptc', 'mst', 'mnv'
											) THEN dar.[d365_bcoa_hq_maneur]
									   ELSE dar.[d365_affiliates_e_g_pakistan]
								   END
	LEFT JOIN {{ ref('currency_rate_mona')}} curr
		ON vij.currencycode = curr.currency_rate_currency_code
		AND FORMAT(vij.invoicedate, 'yyyyMM') = FORMAT(curr.currency_rate_closing_date, 'yyyyMM')
	WHERE (davc.order_value IS NOT NULL
		OR vij.invoiceid IS NOT NULL)
	GROUP BY
		davc.order_value,
		pur.paymentTerms,
		pur.purchaseOrder_id,
		prd.ProdName,
		pur.incoterm,
		vij.dataareaid,
		fil.fileStatus,
		vij.internalinvoiceid,
		vij.invoiceid,
		vij.invoiceaccount,
		pur.latestDelDate,
		vij.modifieddatetime
)

SELECT
    e1.tkey_purchase_invoice_line_cogs,
    e1.bkey_purchase_invoice_line_cogs_source,
    e1.bkey_purchase_invoice_line_cogs,
    e1.bkey_source,
	e1.bkey_flow,
	e1.order_value AS purchase_invoice_line_cogs_file_number,
    e1.paymentTerms AS purchase_invoice_line_cogs_payment_schedule,
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
    e1.fileStatus AS purchase_invoice_line_cogs_purchase_state,
    e1.ccsclosingstatus AS purchase_invoice_line_cogs_ccs_closing_status,
    e1.ecstradetype AS purchase_invoice_line_cogs_ecs_trade_type,
    e1.purchasetype AS purchase_invoice_line_cogs_purchase_type,
    e1.invoiceaccount AS purchase_invoice_line_cogs_invoice_account,
    e1.accountingdate AS purchase_invoice_line_cogs_accounting_date,
    e1.internalinvoiceid AS purchase_invoice_line_cogs_internal_invoice_id,
    e1.ProdName AS purchase_invoice_line_cogs_product,
	e1.purchaseOrder_id AS purchase_invoice_line_cogs_purchase_id,
    e1.linenumber AS purchase_invoice_line_cogs_line_number,
    e1.incoterm AS purchase_invoice_line_cogs_incoterm,
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
    e1.valid_from,
    e1.valid_to,
    CASE 
        WHEN e1.valid_to = '2999-12-31 23:59:59.999999' THEN 1 
        ELSE 0
    END AS is_current
FROM purchase_invoice_line_cogs_history e1