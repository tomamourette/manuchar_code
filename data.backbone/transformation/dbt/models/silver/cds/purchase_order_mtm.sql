WITH purchase_order_history AS (
    SELECT DISTINCT
        ROW_NUMBER() OVER (ORDER BY pur.purchaseOrder_id,
                                    pur.paymentTerms,
                                    vij.createddatetime,
                                    pur.purchaseOrder_id,
                                    vij.dataareaid,
                                    vij.partition,
                                    vij.invoiceaccount,
                                    fil.fileStatus,
                                    vij.invoiceaccount,
                                    vij.invoicedate,
                                    vij.invoiceid,
                                    pur.incoterm,
                                    fil.uom) AS tkey_purchase_order,
        CONVERT(VARCHAR, pur.purchaseOrder_id) + '_' + ISNULL(vij.invoiceaccount, '') + '_' + ISNULL(vij.invoiceid, '') AS bkey_purchase_order,
        CONVERT(VARCHAR, pur.purchaseOrder_id) + '_' + ISNULL(vij.invoiceaccount, '') + '_' + ISNULL(vij.invoiceid, '') + '_MTM' AS bkey_purchase_order_source,
        'MTM' AS bkey_source,
        pur.paymentTerms AS purchase_order_payment_schedule,
        NULL AS purchase_order_payment,
        NULL AS purchase_order_dct_destination,
        NULL AS purchase_order_ecs_contract_status,
        NULL AS purchase_order_risk_trading_book_id,
        vij.createddatetime AS purchase_order_created_date_time,
        vij.dataareaid AS purchase_order_company,
        vij.partition AS purchase_order_partition,
        vij.invoiceaccount AS purchase_order_order_account,
        NULL AS purchase_order_requester,
        NULL AS purchase_order_risk_trader,
        NULL AS purchase_order_worker_purchase_placer,
        fil.fileStatus AS purchase_order_purchase_state,
        NULL AS purchase_order_ccs_closing_status,
        NULL AS purchase_order_ecs_trade_type,
        NULL AS purchase_order_purchase_type,
        vij.invoiceaccount AS purchase_order_invoice_account,
        NULL AS purchase_order_accounting_date,
        vij.invoicedate AS purchase_order_invoice_date,
        SUM(vij.invoiceamount) AS purchase_order_amount_trans_cur,
        SUM(vij.invoiceamountmst) AS purchase_order_amount_func_cur,
        NULL AS purchase_order_amount_group_cur_oanda_eod,
        CONVERT(VARCHAR, NULL) AS purchase_order_transactional_currency_code,
        'USD' AS purchase_order_group_currency_code,
        NULL AS purchase_order_functional_currency_code,
        pur.incoterm AS purchase_order_incoterm,
        SUM(fil.actualQuantity) AS purchase_order_quantity,
        SUM(fil.mrep_quantity) AS purchase_order_quantity_mt,
        fil.uom AS purchase_order_uom,
        CAST(pur.latestDelDate AS DATETIME2(6)) AS valid_from,
        CAST(LEAD(pur.latestDelDate) OVER (PARTITION BY pur.purchaseOrder_id ORDER BY pur.latestDelDate) AS DATETIME2(6)) AS valid_to
    FROM {{ ref('sv_mtm_pd')}} pur LEFT JOIN {{ ref('sv_mtm_fil')}} fil
        ON pur.[file_id] = fil.[file_id]
    LEFT JOIN {{ ref('sv_mtm_filgrid')}} flg
        ON fil.[file_id] = flg.[file_id]
    LEFT JOIN {{ ref('sv_mtm_dim_products')}} prd
        ON flg.product_id = prd.product_id
    LEFT JOIN {{ ref('sv_dynamics_dimensionattributevaluecombination')}} davc
        ON fil.fileNumber = davc.order_value
    LEFT JOIN {{ ref('sv_dynamics_generaljournalaccountentry')}} gjae
        ON davc.recid = gjae.ledgerdimension
    LEFT JOIN {{ ref('sv_dynamics_generaljournalentry')}} gje
        ON gjae.generaljournalentry = gje.recid
    LEFT JOIN {{ ref('sv_dynamics_vendinvoicejour')}} vij
        ON gje.subledgervoucher = vij.ledgervoucher
        AND lower(gje.subledgervoucherdataareaid) = lower(vij.dataareaid)
    WHERE pur.purchaseOrder_id IS NOT NULL
    GROUP BY
        pur.purchaseOrder_id,
        pur.paymentTerms,
        vij.createddatetime,
        pur.purchaseOrder_id,
        vij.dataareaid,
        vij.partition,
        vij.invoiceaccount,
        fil.fileStatus,
        vij.invoiceaccount,
        vij.invoicedate,
        vij.invoiceid,
        pur.incoterm,
        fil.uom,
        vij.recid,
        pur.latestDelDate
 ),

 -- ===============================
-- STEP 2: Generate Time Ranges for SCD2
-- Consolidating timestamps separately for customer and vendor invoices
-- ===============================

purchase_order_timeranges AS (
    SELECT 
        tkey_purchase_order,
        bkey_purchase_order,
        bkey_purchase_order_source,
        CAST(valid_from AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(valid_from) OVER (PARTITION BY bkey_purchase_order ORDER BY valid_from), '2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM purchase_order_history
)

-- ===============================
-- STEP 3: Combine Everything into a Full Entity Timeline
-- - SCD2 (history tables) are joined on recid + valid time range.
-- ===============================

SELECT
    tr.tkey_purchase_order,
    tr.bkey_purchase_order_source,
    tr.bkey_purchase_order,
    e1.bkey_source,
    e1.purchase_order_payment_schedule,
    e1.purchase_order_payment,
    e1.purchase_order_dct_destination,
    e1.purchase_order_ecs_contract_status,
    e1.purchase_order_risk_trading_book_id,
    e1.purchase_order_created_date_time,
    e1.purchase_order_company,
    e1.purchase_order_partition,
    e1.purchase_order_order_account,
    e1.purchase_order_requester,
    e1.purchase_order_risk_trader,
    e1.purchase_order_worker_purchase_placer,
    e1.purchase_order_purchase_state,
    e1.purchase_order_ccs_closing_status,
    e1.purchase_order_ecs_trade_type,
    e1.purchase_order_purchase_type,
    e1.purchase_order_invoice_account,
    e1.purchase_order_accounting_date,
    e1.purchase_order_invoice_date,
    e1.purchase_order_amount_trans_cur,
    e1.purchase_order_amount_func_cur,
    e1.purchase_order_amount_group_cur_oanda_eod,
    CASE
        WHEN curr.currency_rate_closing_rate IS NULL OR curr.currency_rate_closing_rate = 0
            THEN 0
        ELSE 1 / curr.currency_rate_closing_rate
    END AS purchase_order_group_cur_oanda_eod_rate,
    CASE
        WHEN e1.purchase_order_amount_func_cur IS NULL OR e1.purchase_order_amount_func_cur = 0
                THEN 0
            ELSE e1.purchase_order_amount_func_cur / e1.purchase_order_amount_trans_cur
        END AS purchase_order_func_cur_rate,
    e1.purchase_order_transactional_currency_code,
    e1.purchase_order_group_currency_code,
    e1.purchase_order_functional_currency_code,
    e1.purchase_order_incoterm,
    e1.purchase_order_quantity,
    e1.purchase_order_quantity_mt,
    e1.purchase_order_uom,
    tr.valid_from,
    tr.valid_to,
    CASE 
        WHEN tr.valid_to = '2999-12-31 23:59:59.999999' THEN 1 
        ELSE 0
    END AS is_current
FROM purchase_order_timeranges tr
LEFT JOIN purchase_order_history e1
    ON e1.bkey_purchase_order = tr.bkey_purchase_order
    AND e1.valid_from <= tr.valid_from 
    AND COALESCE(e1.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from 
LEFT JOIN dbb_warehouse.cds.currency_rate_mona curr
    ON curr.currency_rate_currency_code = e1.purchase_order_transactional_currency_code
    AND FORMAT(COALESCE(tr.valid_from, e1.purchase_order_invoice_date), 'yyyyMM') = FORMAT(curr.currency_rate_closing_date, 'yyyyMM')