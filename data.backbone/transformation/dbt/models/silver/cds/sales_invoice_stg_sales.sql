WITH staging_sales AS (
    SELECT        
        UPPER(TRIM(sh.Company)) AS Company,
        InvoiceID,
        InvoiceDate,
        sh.ClosureDate,
        TRIM(CustomerID) AS CustomerID,
        --BusinessUnit,
        com.Country_Mapping_Code AS DestinationCountry,
        ExternalReference,
        InvoiceCurrency,
        cgk.Legal_Number,
        COALESCE(ite.Industry_Type_Code, cgk.Industry_Type_Code, '-1') AS IndustryCode,
        CAST(sh.ingestion_timestamp AS DATETIME2(6)) AS valid_from,
        COALESCE(CAST(LEAD(sh.ingestion_timestamp) OVER (PARTITION BY InvoiceID,Company ORDER BY sh.ingestion_timestamp) AS DATETIME2(6)),'2999-12-31 23:59:59.999999') AS valid_to
    FROM {{ ref('sv_stg_stg_sales_hist') }} sh
    INNER JOIN {{ ref('sv_log_validationapprovallog') }} v 
    ON sh.Company = v.CompanyCode 
    AND sh.ClosureDate = v.ClosureDate 
    AND sh.FileName = v.FileName 
    AND v.Status = 'APPROVED'
    
    LEFT JOIN  {{ ref('sv_mds_customertomap') }} ctm 
    ON sh.Company = ctm.Company_Name_Code
    AND sh.CustomerID = ctm.Customer_ID
    AND ctm.ValidationStatus = 'Validation Succeeded'
    LEFT JOIN {{ ref('sv_mds_customermapping') }} cm 
    ON ctm.ID = cm.Customer_To_Map_ID
    AND cm.ValidationStatus = 'Validation Succeeded'
    LEFT JOIN {{ ref('sv_mds_customergoldenkey') }} cgk 
    ON cm.Customer_Golden_Key_ID = cgk.ID
    AND cgk.ValidationStatus = 'Validation Succeeded'

    LEFT JOIN {{ ref('sv_mds_productaffiliatemapping') }} pam
    ON CONCAT(sh.Company, ' - ', sh.LineProductID) = pam.Code

    LEFT JOIN {{ ref('sv_mds_industrytypesexceptions') }} ite
    ON cgk.Code = ite.Customer_Golden_Key_Code
    AND pam.Product_Code = ite.Product_Code

    LEFT JOIN {{ ref('sv_mds_countrymapping') }} com
    ON UPPER(sh.DestinationCountry) = com.Name
    OR sh.DestinationCountry = com.Name
    AND com.ValidationStatus = 'Validation Succeeded'

    WHERE TRY_CAST(LineInvoiceCurrencyTotalAmount AS DECIMAL(18, 2)) <> 0
)

SELECT 
    InvoiceID +'_'+ Company + '_STG_SALES' AS bkey_sales_invoice_source,
    InvoiceID +'_'+ Company  AS bkey_sales_invoice,
    'STG_SALES' as bkey_source,
    InvoiceID AS sales_invoice_id,

    MAX(CustomerID) AS sales_invoice_customer_id,
    NULL AS sales_invoice_order_customer_id,
    Company AS sales_invoice_company,
    MAX(InvoiceCurrency) AS sales_invoice_transactional_currency_code,
    'USD' AS sales_invoice_group_currency_code,
    CONVERT(VARCHAR, NULL) AS sales_invoice_functional_currency_code,
    MAX(InvoiceDate) AS sales_invoice_date,
    NULL AS sales_invoice_document_date,
    NULL AS sales_invoice_due_date, 
    MAX(ClosureDate) AS sales_invoice_closure_date,
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
    NULL AS sales_invoice_func_cur_rate,

    NULL AS sales_invoice_name,
    MAX(Legal_Number) AS sales_invoice_customer_vat,
    MAX(DestinationCountry) AS sales_invoice_destination_country,
    MAX(ExternalReference) AS sales_invoice_external_reference,

    NULL AS sales_invoice_payment_schedule,
    NULL AS sales_invoice_ledger_voucher,
    NULL AS sales_invoice_settled_amount,
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
    MAX(IndustryCode) AS sales_invoice_industry_code,
    NULL sales_invoice_invent_location,
    NULL AS sales_invoice_site_id,
    MIN(stgs.valid_from) AS valid_from,
    MAX(stgs.valid_to) AS valid_to,
    CASE 
        WHEN MAX(stgs.valid_to) = '2999-12-31 23:59:59.999999' THEN 1 
        ELSE 0
    END AS is_current

FROM staging_sales stgs
LEFT JOIN {{ ref("currency_rate_mona") }} curr
    ON curr.currency_rate_currency_code = InvoiceCurrency
    AND FORMAT(TRY_CONVERT(DATETIME2(6), ClosureDate, 103), 'yyyyMM') = FORMAT(curr.currency_rate_closing_date, 'yyyyMM')
GROUP BY Company, InvoiceID
