WITH staging_invoices_payables AS (
    SELECT        
        Company,
        InvoiceID,
        InvoiceDate,
        sh.ClosureDate,
        DueDate,
        UPPER(TRIM(SupplierID)) AS SupplierID,
        InvoiceCurrency,
        CAST(InvoiceAmountInvoiceCurrency AS DECIMAL(18,2)) AS InvoiceAmountInvoiceCurrency,
        CAST(OpenAmountInvoiceCurrency AS DECIMAL(18,2)) AS OpenAmountInvoiceCurrency,
        CAST(OpenAmountHomeCurrency AS DECIMAL(18,2)) AS OpenAmountHomeCurrency,
        PaymentTerm,
        sh.[FILE_NAME],
        CAST(sh.ingestion_timestamp AS DATETIME2(6)) AS valid_from,
        COALESCE(CAST(LEAD(sh.ingestion_timestamp) OVER (PARTITION BY InvoiceID, Company, sh.ClosureDate ORDER BY sh.ingestion_timestamp) AS DATETIME2(6)),'2999-12-31 23:59:59.999999') AS valid_to
    FROM {{ ref('sv_stg_stg_ap_invoices_hist')}} sh
    INNER JOIN {{ ref('sv_log_validationapprovallog')}} v
    ON sh.Company = v.CompanyCode 
    AND sh.ClosureDate = v.ClosureDate 
    AND sh.[FILE_NAME] = v.[FileName]
)

SELECT 
    InvoiceID +'_'+ Company + '_' + ClosureDate +'_STG_AP' AS bkey_invoice_payable_source,
    InvoiceID +'_'+ Company + '_' + ClosureDate AS bkey_invoice_payable,
    'STG_AP' as bkey_source,
    InvoiceID AS invoice_payable_invoice_id,
    MAX(SupplierID) AS invoice_payable_supplier_id,
    Company AS invoice_payable_company,
    MAX(InvoiceCurrency) AS invoice_payable_local_currency_code,
    MAX(InvoiceDate) AS invoice_payable_invoice_date,
    MAX(DueDate) AS invoice_payable_due_date,
    ClosureDate AS invoice_payable_closure_date,
    
    -- Invoice Amounts
    SUM(InvoiceAmountInvoiceCurrency) AS invoice_payable_amount_trans_cur,
    (SUM(OpenAmountHomeCurrency) / NULLIF(SUM(OpenAmountInvoiceCurrency), 0)) * SUM(InvoiceAmountInvoiceCurrency) AS invoice_payable_amount_func_cur,
    SUM(InvoiceAmountInvoiceCurrency) / NULLIF(MAX(curr.currency_rate_closing_rate), 0) AS invoice_payable_amount_group_cur_conso_eom,
    SUM(InvoiceAmountInvoiceCurrency) / NULLIF(MAX(curr.currency_rate_average_month), 0) AS invoice_payable_amount_group_cur_conso_avg,
    NULL AS invoice_payable_amount_group_cur_oanda_eod,

    -- Open Amounts
    SUM(OpenAmountInvoiceCurrency) AS invoice_payable_open_amount_trans_cur,
    SUM(OpenAmountHomeCurrency) AS invoice_payable_open_amount_func_cur,
    SUM(OpenAmountInvoiceCurrency) / NULLIF(MAX(curr.currency_rate_closing_rate), 0) AS invoice_payable_open_amount_group_cur_conso_eom,
    SUM(OpenAmountInvoiceCurrency) / NULLIF(MAX(curr.currency_rate_average_month), 0) AS invoice_payable_open_amount_group_cur_conso_avg,
    NULL AS invoice_payable_open_amount_group_cur_oanda_eod,

    -- Settled Amounts
    SUM(InvoiceAmountInvoiceCurrency) - SUM(OpenAmountInvoiceCurrency) AS invoice_payable_settled_amount_trans_cur,
    ((SUM(OpenAmountHomeCurrency) / NULLIF(SUM(OpenAmountInvoiceCurrency), 0)) * SUM(InvoiceAmountInvoiceCurrency)) - SUM(OpenAmountHomeCurrency) AS invoice_payable_settled_amount_func_cur,
    (SUM(InvoiceAmountInvoiceCurrency) - SUM(OpenAmountInvoiceCurrency)) / NULLIF(MAX(curr.currency_rate_closing_rate), 0) AS invoice_payable_settled_amount_group_cur_conso_eom,
    (SUM(InvoiceAmountInvoiceCurrency) - SUM(OpenAmountInvoiceCurrency)) / NULLIF(MAX(curr.currency_rate_average_month), 0) AS invoice_payable_settled_amount_group_cur_conso_avg,
    NULL AS invoice_payable_settled_amount_group_cur_oanda_eod,

    MAX(PaymentTerm) AS invoice_payable_payment_schedule,
    MAX([FILE_NAME]) AS invoice_payable_file_name,
    MIN(sip.valid_from) AS valid_from,
    MAX(sip.valid_to) AS valid_to,
    CASE 
        WHEN MAX(sip.valid_to) = '2999-12-31 23:59:59.999999' THEN 1 
        ELSE 0
    END AS is_current
FROM staging_invoices_payables sip
LEFT JOIN {{ ref("currency_rate_mona") }} curr
    ON curr.currency_rate_currency_code = InvoiceCurrency
    AND FORMAT(TRY_CONVERT(DATETIME2(6), ClosureDate, 103), 'yyyyMM') = FORMAT(curr.currency_rate_closing_date, 'yyyyMM')
GROUP BY InvoiceID, Company, ClosureDate