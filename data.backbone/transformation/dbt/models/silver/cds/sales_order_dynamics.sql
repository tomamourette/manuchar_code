-- ===============================
-- STEP 1
-- ===============================

WITH sales_order AS (
    SELECT  
        CASE 
            WHEN LEN(ct.txt) - LEN(REPLACE(ct.txt, '-', '')) >= 2 THEN
                SUBSTRING(
                    ct.txt,
                    CHARINDEX('-', ct.txt) + 1,
                    CHARINDEX('-', ct.txt, CHARINDEX('-', ct.txt) + 1) - CHARINDEX('-', ct.txt) - 1
        )
        ELSE NULL
        END AS sales_id,
        gja.transactioncurrencycode AS currencycode,
        ct.accountnum AS custaccount,
        gja.transactioncurrencyamount,
        gja.quantity,
        gja.quantity/ uom.ConversionToMT AS qty_mt,
        gj.accountingdate,
        gj.subledgervoucherdataareaid,
        gj.subledgervoucher,
        dav.mainaccountvalue,
        ledgeraccount,
        dav.procenvalue,
        
        ct.recid AS ct_recid,
        CAST(ct.modifieddatetime AS DATETIME2(6)) AS valid_from,
        CAST(
            LEAD(ct.modifieddatetime) OVER (
                PARTITION BY ct.recid 
                ORDER BY ct.modifieddatetime
            ) AS DATETIME2(6)
        ) AS valid_to
    FROM {{ ref("sv_dynamics_custtrans") }} ct
    LEFT JOIN {{ ref("sv_dynamics_generaljournalentry") }} gj 
        ON ct.voucher = gj.subledgervoucher
    LEFT JOIN {{ ref("sv_dynamics_generaljournalaccountentry") }} gja 
        ON gja.generaljournalentry = gj.recid 
    LEFT JOIN {{ ref("sv_dynamics_dimensionattributevaluecombination") }} dav 
        ON gja.ledgerdimension = dav.recid 
    LEFT JOIN {{ ref("sv_dynamics_lgslogisticfiletable") }} lgs 
        ON dav.logisticsfilevalue = lgs.logisticfileid
    LEFT JOIN  {{ ref("sv_mds_uom") }} uom
        ON UPPER(IIF(lgs.unitid = 'bg', 'kg', lgs.unitid)) = uom.Code
    WHERE 
        SUBSTRING(ct.voucher, 1, 3) = 'ACC'
        AND (LEN(ct.txt) - LEN(REPLACE(ct.txt, '-', '')) >= 2 OR ct.txt IS NOT NULL)
        AND ct.transtype = '36'
        AND LEFT(dav.mainaccountvalue, 1) IN ('6', '7')
),

-- ===============================
-- STEP 3: Generate Time Ranges
-- ===============================

timeranges AS (
    SELECT 
        ct_recid,
        valid_from,
        COALESCE(
            LEAD(valid_from) OVER (
                PARTITION BY ct_recid 
                ORDER BY valid_from
            ),
            '2999-12-31 23:59:59.999999'
        ) AS valid_to
    FROM sales_order
)

-- ===============================
-- STEP 4: Final Output
-- ===============================

SELECT 
    so.sales_id + '_' + so.mainaccountvalue + '_DYNAMICS' AS bkey_sales_order_source,
    so.sales_id  + '_'  + so.mainaccountvalue AS bkey_sales_order,
    'DYNAMICS' AS bkey_source,
    so.sales_id AS sales_order_sales_id,
    so.currencycode AS sales_order_transactional_currency_code,
    'USD' AS sales_order_group_currency_code,
    CONVERT(VARCHAR, NULL) AS sales_order_functional_currency_code,
    so.custaccount AS sales_order_cust_account,
    so.transactioncurrencyamount AS sales_order_sales_amount_accrual,
    so.quantity AS sales_order_sales_volume_accrual,
    so.qty_mt AS sales_order_sales_volume_mt_accrual,
    so.accountingdate AS sales_order_sales_accrual_accounting_date,
    so.subledgervoucherdataareaid AS sales_order_company,
    so.subledgervoucher AS sales_order_ledger_voucher,
    so.mainaccountvalue AS sales_order_ledger_account_value,
    so.ledgeraccount AS sales_order_ledger_account,
    so.procenvalue AS sales_order_procen_value,
    tr.valid_from,
    tr.valid_to,
    CASE 
        WHEN tr.valid_to = '2999-12-31 23:59:59.999999' THEN 1 
        ELSE 0
    END AS is_current
FROM timeranges tr
LEFT JOIN sales_order so 
    ON so.ct_recid = tr.ct_recid
    AND so.valid_from <= tr.valid_from
    AND COALESCE(so.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
