-- ===============================
-- STEP 1: Extracting Historical Data (SCD2)
-- Generating valid_from and valid_to using modifieddate
-- ===============================

WITH purchase_order_history AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY pur.recid, 
                                    pur.paymentsched, 
                                    pur.payment, 
                                    pur.dctdestination, 
                                    pur.ecscontractstatus,
                                    pur.rsktradingbookid,
                                    pur.createddatetime,
                                    pur.purchid,
                                    pur.dataareaid,
                                    pur.partition,
                                    pur.orderaccount,
                                    pur.requester,
                                    pur.rsktrader,
                                    pur.workerpurchplacer,
                                    pur.purchstatus,
                                    pur.ccsclosingstatus,
                                    pur.ecstradetype,
                                    pur.purchasetype,
                                    pur.invoiceaccount,
                                    pur.accountingdate,
                                    vij.invoicedate,
                                    vij.invoiceamount,
                                    vij.invoiceamountmst,
                                    vij.internalinvoiceid,
                                    vit.name,
                                    vit.itemid,
                                    vit.currencycode,
                                    vit.linenum,
                                    purl.dlvterm,
                                    lft.origincountryid,
                                    lft.destinationcountryid) AS tkey_purchase_order,
        pur.recid,
        pur.paymentsched,
	    pur.payment,
	    pur.dctdestination,
	    pur.ecscontractstatus,
	    pur.rsktradingbookid,
	    pur.createddatetime,
	    pur.purchid,
	    pur.dataareaid,
	    pur.partition,
	    pur.orderaccount,
	    pur.requester,
	    pur.rsktrader,
	    pur.workerpurchplacer,
	    pur.purchstatus,
	    pur.ccsclosingstatus,
	    pur.ecstradetype,
	    pur.purchasetype,
	    pur.invoiceaccount,
        pur.accountingdate,
        vij.invoicedate,
        vij.invoiceamount,
        vij.invoiceamountmst,
        vij.internalinvoiceid,
        vit.name,
        vit.itemid,
        vit.currencycode,
        vit.linenum,
        purl.dlvterm,
        lft.origincountryid,
		lft.destinationcountryid,
        IIF(vit.purchunit = 'bg', vit.qty * CAST(LEFT(ivs.inventsizeid, COALESCE(CHARINDEX('kg', ivs.inventsizeid), 1)-1) AS INT), vit.qty) AS qty,
        IIF(vit.purchunit = 'bg', vit.qty * CAST(LEFT(ivs.inventsizeid, COALESCE(CHARINDEX('kg', ivs.inventsizeid), 1)-1) AS INT), vit.qty) / uom.ConversionToMT AS qty_mt,
        IIF(vit.purchunit = 'bg', 'kg', vit.purchunit) AS uom,
        CAST(pur.modifieddatetime AS DATETIME2(6)) AS valid_from,
        CAST(LEAD(pur.modifieddatetime) OVER (PARTITION BY pur.recid ORDER BY pur.modifieddatetime) AS DATETIME2(6)) AS valid_to
    FROM {{ ref('sv_dynamics_purchtable')}} pur
    LEFT JOIN {{ ref('sv_dynamics_vendinvoicejour')}} vij
        ON pur.purchid = vij.purchid
        AND pur.dataareaid = vij.dataareaid
    LEFT JOIN {{ ref('sv_dynamics_vendinvoicetrans')}} vit
        ON vij.purchid = vit.purchid
        AND vij.invoiceid = vit.invoiceid
	    AND vij.invoicedate = vit.invoicedate
	    AND vij.internalinvoiceid = vit.internalinvoiceid
    LEFT JOIN {{ ref('sv_dynamics_purchline')}} purl
        ON vit.purchid = purl.purchid
        AND vit.linenum = purl.linenumber
        AND vit.dataareaid = purl.dataareaid
    LEFT JOIN {{ ref('sv_dynamics_inventsum')}} ivs
        ON vit.itemid = ivs.itemid
        AND vit.inventdimid = ivs.inventdimid
    LEFT JOIN {{ ref('sv_dynamics_lgslogisticfiletable')}} lft
        ON vij.lgslogisticfileid = lft.logisticfileid
    LEFT JOIN {{ ref('sv_mds_uom')}} uom
		ON UPPER(IIF(vit.purchunit = 'bg', 'kg', vit.purchunit)) = uom.Code
    WHERE pur.dataareaid NOT IN ('acem', 'acemus', 'bau', 'mppa', 'mshan', 'mst', 'msthk', 'mwoo', 'ptc', 'tradum', 'meur')
),

-- ===============================
-- STEP 2: Generate Time Ranges for SCD2
-- Consolidating timestamps separately for customer and vendor invoices
-- ===============================

purchase_order_timeranges AS (
    SELECT 
        tkey_purchase_order,
        CAST(valid_from AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(valid_from) OVER (PARTITION BY tkey_purchase_order ORDER BY valid_from), '2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM purchase_order_history
)

-- ===============================
-- STEP 3: Combine Everything into a Full Entity Timeline
-- - SCD2 (history tables) are joined on recid + valid time range.
-- ===============================

SELECT
    tr.tkey_purchase_order,
    e1.purchid + '_DYNAMICS' AS bkey_purchase_order_source,
    e1.purchid AS bkey_purchase_order,
    'DYNAMICS' AS bkey_source,
    e1.purchid AS purchase_order_id,
    e1.dataareaid AS purchase_order_company,
    e1.invoicedate AS purchase_order_date,
    e1.paymentsched AS purchase_order_payment_schedule,
    e1.payment AS purchase_order_payment,
    e1.dctdestination AS purchase_order_dct_destination,
    e1.ecscontractstatus AS purchase_order_ecs_contract_status,
    e1.rsktradingbookid AS purchase_order_risk_trading_book_id,
    e1.createddatetime AS purchase_order_created_date_time,    
    e1.partition AS purchase_order_partition,
    e1.orderaccount AS purchase_order_order_account,
    e1.requester AS purchase_order_requester,
    e1.rsktrader AS purchase_order_risk_trader,
    e1.workerpurchplacer AS purchase_order_worker_purchase_placer,
    e1.purchstatus AS purchase_order_purchase_state,
    e1.ccsclosingstatus AS purchase_order_ccs_closing_status,
    e1.ecstradetype AS purchase_order_ecs_trade_type,
    e1.purchasetype AS purchase_order_purchase_type,
    e1.invoiceaccount AS purchase_order_invoice_account,
    e1.accountingdate AS purchase_order_accounting_date,
    e1.invoicedate AS purchase_order_invoice_date,
    e1.internalinvoiceid AS purchase_order_internal_invoice_id,
    -- Invoice Amounts
    e1.invoiceamount  AS purchase_order_amount_trans_cur,
    e1.invoiceamountmst AS purchase_order_amount_func_cur,
    NULL AS purchase_order_amount_group_cur_oanda_eod,
    -- Invoice Rates
    NULL AS purchase_order_group_cur_oanda_eod_rate,
    CASE
        WHEN e1.invoiceamountmst IS NULL OR e1.invoiceamountmst = 0
           THEN 0
        ELSE e1.invoiceamountmst / e1.invoiceamount
    END AS purchase_order_func_cur_rate,

    e1.name AS purchase_order_local_product,
    e1.itemid AS purchase_order_product,
    e1.currencycode AS purchase_order_transactional_currency_code,
    'USD' AS purchase_order_group_currency_code,
    CONVERT(VARCHAR, NULL) AS purchase_order_functional_currency_code,
    e1.linenum AS purchase_order_line_number,
    e1.dlvterm AS purchase_order_incoterm,
    e1.origincountryid AS purchase_order_origin_country,
    e1.destinationcountryid AS purchase_order_destination_country,
    e1.qty AS purchase_order_quantity,
    e1.qty_mt AS purchase_order_quantity_mt,
    e1.uom AS purchase_order_uom,
    tr.valid_from,
    tr.valid_to,
    CASE 
        WHEN tr.valid_to = '2999-12-31 23:59:59.999999' THEN 1 
        ELSE 0
    END AS is_current
FROM purchase_order_timeranges tr
LEFT JOIN purchase_order_history e1
    ON e1.tkey_purchase_order = tr.tkey_purchase_order
    AND e1.valid_from <= tr.valid_from 
    AND COALESCE(e1.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from 

LEFT JOIN dbb_warehouse.cds.currency_rate_mona curr
    ON curr.currency_rate_currency_code = e1.currencycode
    AND FORMAT(COALESCE(tr.valid_from, e1.invoicedate), 'yyyyMM') = FORMAT(curr.currency_rate_closing_date, 'yyyyMM')