WITH
-- ========================================
-- STEP 1: Customer Invoice Transaction + InventTrans (Product Detail)
-- ========================================
detailed_lines AS (
    SELECT 
        cit.invoiceid,
        cit.dataareaid,
        cit.linenum,
        cit.name,
        cit.qty,
        cit.salesunit,
        cit.currencycode,
        cit.lineamount,
        cit.lineamountmst,
        cit.itemid,
        COALESCE(it.costamountposted, 0) AS costamountposted
    FROM {{ ref('sv_dynamics_custinvoicetrans') }} cit
    LEFT JOIN {{ ref('sv_dynamics_inventtrans') }} it
        ON cit.invoiceid = it.invoiceid AND cit.itemid = it.itemid
    WHERE cit.invoiceid IS NOT NULL
),

-- ========================================
-- STEP 2: General Journal Entries (COGS Info) without cit/it
-- ========================================
journal_lines AS (
    SELECT 
        gjae.recid,
        gje.subledgervoucherdataareaid,
        cij.invoiceid,
        ct.txt,
        CASE 
            WHEN cij.invoiceid IS NULL AND ct.txt IS NOT NULL AND CHARINDEX('-', ct.txt) > 0 THEN 
                LEFT(ct.txt, CHARINDEX('-', ct.txt) - 1)
            ELSE cij.invoiceid
        END AS invoice,
        mapping.report,
        gjae.transactioncurrencyamount,
        gjae.transactioncurrencycode,
        gjae.reportingcurrencyamount,
        gjae.accountingcurrencyamount,
        CAST(gjae.modifieddatetime AS DATETIME2(6)) AS valid_from
    FROM {{ ref('sv_dynamics_generaljournalaccountentry') }} gjae
    LEFT JOIN {{ ref('sv_dynamics_generaljournalentry') }} gje 
        ON gje.recid = gjae.generaljournalentry
    LEFT JOIN {{ ref('sv_dynamics_custinvoicejour') }} cij  
        ON cij.ledgervoucher = gje.subledgervoucher
        AND cij.dataareaid = gje.subledgervoucherdataareaid
    LEFT JOIN {{ ref('sv_dynamics_custtrans') }} ct 
        ON gje.subledgervoucher = ct.voucher
    LEFT JOIN {{ ref('sv_dynamics_dimensionattributevaluecombination') }} davc
        ON gjae.ledgerdimension = davc.recid
    LEFT JOIN {{ ref('sv_dbb_lakehouse_d365accounts_report') }}  mapping
        ON davc.mainaccountvalue = CASE
            WHEN UPPER(gje.subledgervoucherdataareaid) IN (
                'MITS', 'MEUR', 'LDINT', 'EXP', 'BAU',
                'MWOO', 'MPPA', 'UI', 'PTC', 'MST', 'MNV'
            ) THEN mapping.[d365_bcoa_hq_maneur]
            ELSE mapping.[d365_affiliates_e_g_pakistan]
        END
    WHERE ct.transtype IN ('36','24','8','9') 
        AND SUBSTRING(gjae.ledgeraccount, 1, 1) IN ('6', '7') 
        AND mapping.report IS NOT NULL
        AND (
            CASE 
                WHEN cij.invoiceid IS NULL AND ct.txt IS NOT NULL AND CHARINDEX('-', ct.txt) > 0 THEN 
                    LEFT(ct.txt, CHARINDEX('-', ct.txt) - 1)
                ELSE cij.invoiceid
            END
        ) IS NOT NULL
),

-- ========================================
-- STEP 3: Build Valid Time Ranges
-- ========================================
timeline AS (
    SELECT 
        recid,
        valid_from,
        COALESCE(LEAD(valid_from) OVER (PARTITION BY recid ORDER BY valid_from), '2999-12-31 23:59:59.999999') AS valid_to
    FROM journal_lines
),

-- ========================================
-- STEP 4: Join Detailed Product Lines with Journal Data
-- ========================================
joined_data AS (
    SELECT 
        jl.recid,
        jl.subledgervoucherdataareaid as dataareaid,
        jl.invoice,
        dl.linenum,
        dl.qty,
        dl.lineamount,
        dl.lineamountmst,
        dl.itemid,
        dl.salesunit,
        dl.currencycode,
        dl.costamountposted,
        jl.transactioncurrencyamount,
        jl.transactioncurrencycode,
        jl.reportingcurrencyamount,
        jl.accountingcurrencyamount,
        jl.report,
        jl.valid_from
    FROM journal_lines jl
    LEFT JOIN detailed_lines dl
        ON jl.invoice = dl.invoiceid
    WHERE jl.invoice IS NOT NULL
)

-- ========================================
-- STEP 5: Final Aggregated Output
-- ========================================
SELECT 
    jd.invoice + '_' + CAST(CAST(jd.linenum AS DECIMAL(18, 0)) AS VARCHAR) + '_' + jd.dataareaid + '_DYNAMICS' AS bkey_sales_invoice_line_cogs_source,

    jd.invoice + '_' + CAST(CAST(jd.linenum AS DECIMAL(18, 0)) AS VARCHAR) + '_' + jd.dataareaid AS bkey_sales_invoice_line_cogs,

    jd.invoice + '_' + jd.dataareaid AS bkey_sales_invoice,

    'DYNAMICS' AS bkey_source,
    jd.dataareaid AS sales_invoice_line_cogs_company,
    jd.invoice AS sales_invoice_line_cogs_invoice_id,
    jd.linenum AS sales_invoice_line_cogs_line_num,
    SUM(jd.qty) AS sales_invoice_line_cogs_quantity,
    MAX(jd.salesunit) AS sales_invoice_line_cogs_uom,
    MAX(jd.currencycode) AS sales_invoice_line_cogs_currency_code,
    MAX(jd.itemid) AS sales_invoice_line_product_id,
    NULL AS csv_sales_amount_m_local,
    NULL AS csv_sales_amount_m_home,
    SUM(jd.lineamount) AS erp_sales_amount_m_local,
    SUM(jd.lineamountmst) AS erp_sales_amount_m_home,
    SUM(jd.costamountposted) AS erp_cost_amount_posted,

    -- New Dynamics COGS Mappings
    SUM(CASE WHEN jd.report = 'COGS1 Purchase Amount' THEN jd.transactioncurrencyamount ELSE 0 END) AS erp_cogs1_purchase_amount_m_local,
    MAX(CASE WHEN jd.report = 'COGS1 Purchase Amount' THEN jd.transactioncurrencycode ELSE '' END) AS erp_cogs1_purchase_amount_m_local_currency,
    SUM(CASE WHEN jd.report = 'COGS1 Purchase Amount' THEN jd.reportingcurrencyamount ELSE 0 END) AS erp_cogs1_purchase_amount_m_home,
    SUM(CASE WHEN jd.report = 'COGS1 Purchase Amount' THEN jd.accountingcurrencyamount ELSE 0 END) AS erp_cogs1_purchase_amount_m_group,

    SUM(CASE WHEN jd.report = 'COGS1 Freight Amount' THEN jd.transactioncurrencyamount ELSE 0 END) AS erp_cogs1_freight_amount_m_local,
    MAX(CASE WHEN jd.report = 'COGS1 Freight Amount' THEN jd.transactioncurrencycode ELSE '' END) AS erp_cogs1_freight_amount_m_local_currency,
    SUM(CASE WHEN jd.report = 'COGS1 Freight Amount' THEN jd.reportingcurrencyamount ELSE 0 END) AS erp_cogs1_freight_amount_m_home,
    SUM(CASE WHEN jd.report = 'COGS1 Freight Amount' THEN jd.accountingcurrencyamount ELSE 0 END) AS erp_cogs1_freight_amount_m_group,

    SUM(CASE WHEN jd.report = 'COGS1 Other Amount' THEN jd.transactioncurrencyamount ELSE 0 END) AS erp_cogs1_other_amount_m_local,
    MAX(CASE WHEN jd.report = 'COGS1 Other Amount' THEN jd.transactioncurrencycode ELSE '' END) AS erp_cogs1_other_amount_m_local_currency,
    SUM(CASE WHEN jd.report = 'COGS1 Other Amount' THEN jd.reportingcurrencyamount ELSE 0 END) AS erp_cogs1_other_amount_m_home,
    SUM(CASE WHEN jd.report = 'COGS1 Other Amount' THEN jd.accountingcurrencyamount ELSE 0 END) AS erp_cogs1_other_amount_m_group,

    SUM(CASE WHEN jd.report = 'Adjusted COGS' THEN jd.transactioncurrencyamount ELSE 0 END) AS erp_cogs1_amount_m_local,
    MAX(CASE WHEN jd.report = 'Adjusted COGS' THEN jd.transactioncurrencycode ELSE '' END) AS erp_cogs1_amount_m_local_currency,
    SUM(CASE WHEN jd.report = 'Adjusted COGS' THEN jd.reportingcurrencyamount ELSE 0 END) AS erp_cogs1_amount_m_home,
    SUM(CASE WHEN jd.report = 'Adjusted COGS' THEN jd.accountingcurrencyamount ELSE 0 END) AS erp_cogs1_amount_m_group,

    SUM(CASE WHEN jd.report = 'COGS2 Amount Transport Internal' THEN jd.transactioncurrencyamount ELSE 0 END) AS erp_cogs2_internal_transport_amount_m_local,
    MAX(CASE WHEN jd.report = 'COGS2 Amount Transport Internal' THEN jd.transactioncurrencycode ELSE '' END) AS erp_cogs2_internal_transport_amount_m_local_currency,
    SUM(CASE WHEN jd.report = 'COGS2 Amount Transport Internal' THEN jd.reportingcurrencyamount ELSE 0 END) AS erp_cogs2_internal_transport_amount_m_home,
    SUM(CASE WHEN jd.report = 'COGS2 Amount Transport Internal' THEN jd.accountingcurrencyamount ELSE 0 END) AS erp_cogs2_internal_transport_amount_m_group,

    SUM(CASE WHEN jd.report = 'Amount Transport External' THEN jd.transactioncurrencyamount ELSE 0 END) AS erp_cogs2_external_transport_amount_m_local,
    MAX(CASE WHEN jd.report = 'Amount Transport External' THEN jd.transactioncurrencycode ELSE '' END) AS erp_cogs2_external_transport_amount_m_local_currency,
    SUM(CASE WHEN jd.report = 'Amount Transport External' THEN jd.reportingcurrencyamount ELSE 0 END) AS erp_cogs2_external_transport_amount_m_home,
    SUM(CASE WHEN jd.report = 'Amount Transport External' THEN jd.accountingcurrencyamount ELSE 0 END) AS erp_cogs2_external_transport_amount_m_group,

    SUM(CASE WHEN jd.report = 'COGS2 Amount Other COGS2' THEN jd.transactioncurrencyamount ELSE 0 END) AS erp_cogs2_other_amount_m_local,
    MAX(CASE WHEN jd.report = 'COGS2 Amount Other COGS2' THEN jd.transactioncurrencycode ELSE '' END) AS erp_cogs2_other_amount_m_local_currency,
    SUM(CASE WHEN jd.report = 'COGS2 Amount Other COGS2' THEN jd.reportingcurrencyamount ELSE 0 END) AS erp_cogs2_other_amount_m_home,
    SUM(CASE WHEN jd.report = 'COGS2 Amount Other COGS2' THEN jd.accountingcurrencyamount ELSE 0 END) AS erp_cogs2_other_amount_m_group,

    -- New STG COGS column
    NULL AS csv_cogs1_amount,
    NULL AS csv_external_transport_amount,
    NULL AS csv_internal_transport_amount,
    NULL AS csv_other_cogs2_amount,
    NULL AS csv_cogs2_amount,

    MIN(tl.valid_from) AS valid_from,
    MAX(tl.valid_to) AS valid_to,
    CASE WHEN MAX(tl.valid_to) = '2999-12-31 23:59:59.999999' THEN 1 ELSE 0 END AS is_current

FROM joined_data jd
JOIN timeline tl ON jd.recid = tl.recid
    AND jd.valid_from >= tl.valid_from
    AND jd.valid_from < tl.valid_to
    where jd.dataareaid is not null
GROUP BY 
    jd.dataareaid,
    jd.invoice,
    jd.linenum;
