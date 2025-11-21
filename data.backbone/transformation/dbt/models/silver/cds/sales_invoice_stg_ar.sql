WITH staging_invoices_receivable AS (
    SELECT        
        UPPER(TRIM(Company)) AS Company,
        InvoiceID,
        InvoiceDate,
        sh.ClosureDate,
        DueDate,
        TRIM(CustomerID) AS CustomerID,
        InvoiceCurrency,
        CAST(InvoiceAmountInvoiceCurrency AS DECIMAL(18,2)) AS InvoiceAmountInvoiceCurrency,
        CAST(OpenAmountInvoiceCurrency AS DECIMAL(18,2)) AS OpenAmountInvoiceCurrency,
        CAST(OpenAmountHomeCurrency AS DECIMAL(18,2)) AS OpenAmountHomeCurrency,
        PaymentTerm,
        BusinessUnit,
        LegalNumber,
        sh.FileName,
        CAST(sh.ingestion_timestamp AS DATETIME2(6)) AS valid_from,
        COALESCE(CAST(LEAD(sh.ingestion_timestamp) OVER (PARTITION BY InvoiceID, Company, sh.ClosureDate ORDER BY sh.ingestion_timestamp) AS DATETIME2(6)),'2999-12-31 23:59:59.999999') AS valid_to
    FROM {{ ref('sv_stg_stg_ar_invoices_hist') }} sh
    INNER JOIN {{ ref('sv_log_validationapprovallog') }} v 
        ON sh.Company = v.CompanyCode 
        AND sh.ClosureDate = v.ClosureDate 
        AND sh.FileName = v.FileName 
        -- Include all MNV invoices for 2023 (including EUChem) as they have a status of "rejected" or "waiting for approval."
        AND (v.Status = 'APPROVED' OR (sh.Company = 'MNV' AND RIGHT(sh.ClosureDate, 4) = '2023')) 
)

SELECT 
    InvoiceID + '_' + Company + '_' + ClosureDate +'_STG_AR' AS bkey_sales_invoice_source,
    InvoiceID + '_' + Company + '_' + ClosureDate AS bkey_sales_invoice,
    'STG_AR' as bkey_source,
    InvoiceID AS sales_invoice_id,
    MAX(CustomerID) AS sales_invoice_customer_id,
    CONVERT(VARCHAR, NULL) AS sales_invoice_order_customer_id,
    Company AS sales_invoice_company,
    MAX(InvoiceCurrency) AS sales_invoice_transactional_currency_code,
    'USD' AS sales_invoice_group_currency_code,
    NULL AS sales_invoice_functional_currency_code,
    MAX(InvoiceDate) AS sales_invoice_date,
    NULL AS sales_invoice_document_date,
    MAX(DueDate) AS sales_invoice_due_date,
    ClosureDate AS sales_invoice_closure_date,
    
    -- Invoice Amounts
    SUM(InvoiceAmountInvoiceCurrency) AS sales_invoice_amount_trans_cur,
    (SUM(OpenAmountHomeCurrency) / NULLIF(SUM(OpenAmountInvoiceCurrency), 0)) * SUM(InvoiceAmountInvoiceCurrency) AS sales_invoice_amount_func_cur,
    SUM(InvoiceAmountInvoiceCurrency) / NULLIF(MAX(curr.currency_rate_closing_rate), 0) AS sales_invoice_amount_group_cur_conso_eom,
    SUM(InvoiceAmountInvoiceCurrency) / NULLIF(MAX(curr.currency_rate_average_month), 0) AS sales_invoice_amount_group_cur_conso_avg,
    NULL AS sales_invoice_amount_group_cur_oanda_eod,

    -- Open Amounts
    SUM(OpenAmountInvoiceCurrency) AS sales_invoice_open_amount_trans_cur,
    SUM(OpenAmountHomeCurrency) AS sales_invoice_open_amount_func_cur,
    SUM(OpenAmountInvoiceCurrency) / NULLIF(MAX(curr.currency_rate_closing_rate), 0) AS sales_invoice_open_amount_group_cur_conso_eom,
    SUM(OpenAmountInvoiceCurrency) / NULLIF(MAX(curr.currency_rate_average_month), 0) AS sales_invoice_open_amount_group_cur_conso_avg,
    NULL AS sales_invoice_open_amount_group_cur_oanda_eod,

    -- Settled Amounts
    SUM(InvoiceAmountInvoiceCurrency) - SUM(OpenAmountInvoiceCurrency) AS sales_invoice_settled_amount_trans_cur,
    ((SUM(OpenAmountHomeCurrency) / NULLIF(SUM(OpenAmountInvoiceCurrency), 0)) * SUM(InvoiceAmountInvoiceCurrency)) - SUM(OpenAmountHomeCurrency) AS sales_invoice_settled_amount_func_cur,
    (SUM(InvoiceAmountInvoiceCurrency) - SUM(OpenAmountInvoiceCurrency)) / NULLIF(MAX(curr.currency_rate_closing_rate), 0) AS sales_invoice_settled_amount_group_cur_conso_eom,
    (SUM(InvoiceAmountInvoiceCurrency) - SUM(OpenAmountInvoiceCurrency)) / NULLIF(MAX(curr.currency_rate_average_month), 0) AS sales_invoice_settled_amount_group_cur_conso_avg,
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
        WHEN SUM(OpenAmountHomeCurrency) IS NULL OR SUM(OpenAmountHomeCurrency) = 0
            THEN 0
        ELSE ((SUM(OpenAmountHomeCurrency) / NULLIF(SUM(OpenAmountInvoiceCurrency), 0)) * SUM(InvoiceAmountInvoiceCurrency)) / SUM(InvoiceAmountInvoiceCurrency)
    END AS sales_invoice_func_cur_rate,

    NULL AS sales_invoice_name,
    MAX(LegalNumber) AS sales_invoice_customer_vat,
    NULL AS sales_invoice_destination_country,
    NULL AS sales_invoice_external_reference,
    MAX(PaymentTerm) AS sales_invoice_payment_schedule,
    NULL AS sales_invoice_ledger_voucher,
    NULL AS sales_invoice_order_value,
    NULL AS sales_invoice_payment,
    NULL AS sales_invoice_txt,
    NULL AS sales_invoice_closed,
    NULL AS sales_invoice_payment_reference,
    NULL AS sales_invoice_paymtermid,
    NULL AS sales_invoice_procenvalue,
    NULL AS sales_invoice_coscenvalue,
    NULL AS sales_invoice_logistic_id,
    NULL AS sales_invoice_ledger_account,
    NULL AS sales_invoice_industry_code,
    NULL AS sales_invoice_invent_location,
    NULL AS sales_invoice_site_id,
    MIN(sir.valid_from) AS valid_from,
    MAX(sir.valid_to) AS valid_to,
    CASE 
        WHEN MAX(sir.valid_to) = '2999-12-31 23:59:59.999999' THEN 1 
        ELSE 0
    END AS is_current

FROM staging_invoices_receivable sir
LEFT JOIN {{ ref("currency_rate_mona") }} curr
    ON curr.currency_rate_currency_code = InvoiceCurrency
    AND FORMAT(TRY_CONVERT(DATETIME2(6), ClosureDate, 103), 'yyyyMM') = FORMAT(curr.currency_rate_closing_date, 'yyyyMM')
GROUP BY InvoiceID, Company, ClosureDate