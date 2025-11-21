WITH staging_sales AS (
    SELECT 
        InvoiceID,
        sh.ClosureDate,  
        Company,   
        InvoiceCurrency,  
        LineProductID,
        LineProductName,
        LineQuantity,
        LineUOM,
        LineInvoiceCurrencyTotalAmount,
        LineHomeCurrencyTotalAmount,
        LineHomeCurrencyCOGSAmount,
        LineHomeCurrencyExternalTransportAmount,
        LineHomeCurrencyInternalTransportAmount,
        LineHomeCurrencyOtherCOGS2Amount,
        pam.Product_Code,
        pg.Product_Business_Unit_Name,
        CAST(sh.LineQuantity AS DECIMAL(38, 5)) AS Quantity,
        CAST(sh.LineQuantity AS DECIMAL(38, 5))/ uom.[ConversionToMT] AS [QuantityInMetricTon],
        sh.ingestion_timestamp
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
    LEFT JOIN  
    {{ ref('sv_mds_productaffiliatemapping') }} pam
    ON CONCAT(sh.Company, ' - ', sh.LineProductID) = pam.Code

    LEFT JOIN 
    {{ ref('sv_mds_productgroupingmapping') }} pgm
    ON pam.Product_Code = pgm.Product_Grouping_Code_Code
    AND (cgk.Code = pgm.Customer_Code OR pgm.Default_Code = '1')

    LEFT JOIN 
    {{ ref('sv_mds_productgrouping') }}pg 
    ON pgm.Product_Grouping_Code_Code = pg.Code

    LEFT JOIN {{ ref('sv_mds_uom') }}  uom
    ON UPPER(sh.LineUOM) = uom.Code

),

-- Step 1: Filter only main lines (non zero amount)
main_sales AS (
    SELECT *
    FROM staging_sales
    WHERE CAST(LineInvoiceCurrencyTotalAmount AS DECIMAL(18,4)) <> 0
),

-- Step 2: Assign line numbers to each product within invoice
product_line_numbers AS (
    SELECT
        InvoiceID,
        Company,
        LineProductID,
        
        DENSE_RANK() OVER (
            PARTITION BY InvoiceID, Company
            ORDER BY LineProductID
        ) AS InvoiceLineNum
    FROM (
        SELECT DISTINCT 
            InvoiceID,
            Company,
            LineProductID
        
        FROM main_sales
    ) t
),

-- Step 3: Join line numbers back to main records
main_lines_with_num AS (
    SELECT 
        m.*,
        pln.InvoiceLineNum
    FROM main_sales m
    JOIN product_line_numbers pln
      ON m.InvoiceID = pln.InvoiceID
     AND m.Company = pln.Company
     AND m.LineProductID = pln.LineProductID
),

-- Step 4: Add valid_from and valid_to based on ingestion timestamps
main_deduped_with_validity AS (
    SELECT 
        *,
        CAST(ingestion_timestamp AS DATETIME2(6)) AS valid_from,
        COALESCE(
            CAST(
                LEAD(ingestion_timestamp) OVER (
                    PARTITION BY InvoiceID, Company, LineProductID
                    ORDER BY ingestion_timestamp
                ) AS DATETIME2(6)
            ),
            '2999-12-31 23:59:59.999999'
        ) AS valid_to
    FROM main_lines_with_num
),

-- Step 5: Aggregate the main lines at desired grain
main_line_aggregates AS (
    SELECT 
        InvoiceID,
        Company,
        InvoiceLineNum,
        LineProductID,
        ClosureDate,

        -- Representative values from the main lines
        MAX(Product_Code) AS LineProductCode,
        MAX(Product_Business_Unit_Name) AS LineBU,
        MAX(LineProductName) AS LineProductName,
        
        SUM(CAST(LineQuantity AS DECIMAL(18,2))) AS LineQuantity,
        SUM(QuantityInMetricTon) as LineQuantityMT,
        MIN(LineUOM) AS LineUOM,
        SUM(CAST(LineInvoiceCurrencyTotalAmount AS DECIMAL(18,4))) AS LineInvoiceCurrencyTotalAmount,
        SUM(CAST(LineHomeCurrencyTotalAmount AS DECIMAL(18,4))) AS LineHomeCurrencyTotalAmount,
        MIN(InvoiceCurrency) AS InvoiceCurrency,

        MIN(valid_from) AS valid_from,
        MAX(valid_to) AS valid_to

    FROM main_deduped_with_validity
    GROUP BY InvoiceID, Company, InvoiceLineNum, LineProductID, ClosureDate
),

-- Step 6: Aggregate supporting cost values
supporting_aggregates AS (
    SELECT 
        InvoiceID,
        Company,
        LineProductID,
        SUM(CAST(LineHomeCurrencyCOGSAmount AS DECIMAL(18,4))) AS total_cogs,
        SUM(CAST(LineHomeCurrencyExternalTransportAmount AS DECIMAL(18,4))) AS total_external_transport,
        SUM(CAST(LineHomeCurrencyInternalTransportAmount AS DECIMAL(18,4))) AS total_internal_transport,
        SUM(CAST(LineHomeCurrencyOtherCOGS2Amount AS DECIMAL(18,4))) AS total_other_cogs2
    FROM staging_sales
    GROUP BY InvoiceID, Company, LineProductID
),

-- Step 7: Join aggregated main with support costs
final_sales_lines AS (
    SELECT 
        m.*,
        COALESCE(s.total_cogs, 0) AS support_total_cogs,
        COALESCE(s.total_external_transport, 0) AS support_total_external_transport,
        COALESCE(s.total_internal_transport, 0) AS support_total_internal_transport,
        COALESCE(s.total_other_cogs2, 0) AS support_total_other_cogs2
    FROM main_line_aggregates m 
    LEFT JOIN supporting_aggregates s 
      ON m.InvoiceID = s.InvoiceID
     AND m.Company = s.Company
     AND m.LineProductID = s.LineProductID
)

-- Final output
SELECT 
    InvoiceID + '_' + CAST(InvoiceLineNum AS VARCHAR) + '_' + Company + '_STG_SALES' AS bkey_sales_invoice_line_source,
    InvoiceID + '_' + CAST(InvoiceLineNum AS VARCHAR) + '_' + Company AS bkey_sales_invoice_line,
    InvoiceID + '_' + Company AS bkey_sales_invoice,
    'STG_SALES' AS bkey_source,
    InvoiceID AS sales_invoice_id,

    InvoiceLineNum AS sales_invoice_line_invoice_line_num,
    
    LineProductID AS sales_invoice_line_product_id,
    LineProductName AS sales_invoice_line_product_name,
    LineQuantity AS sales_invoice_line_quantity,
    LineQuantityMT AS sales_invoice_line_quantity_mt,
    
    LineUOM AS sales_invoice_line_uom,

    -- Invoice Line Amounts
    LineInvoiceCurrencyTotalAmount AS sales_invoice_line_amount_trans_cur,
    LineHomeCurrencyTotalAmount AS sales_invoice_line_amount_func_cur,
    LineInvoiceCurrencyTotalAmount / NULLIF(curr.currency_rate_average_month, 0) AS sales_invoice_line_amount_group_cur_conso_avg,
    NULL AS sales_invoice_line_amount_group_cur_oanda_eod,
    -- Invoice Line Rates:
    CASE
        WHEN curr.currency_rate_closing_rate IS NULL OR curr.currency_rate_closing_rate = 0
            THEN 0
        ELSE 1 / curr.currency_rate_closing_rate
    END AS sales_invoice_line_group_cur_conso_eom_rate,
    CASE
        WHEN curr.currency_rate_average_month IS NULL OR curr.currency_rate_average_month = 0
            THEN 0
        ELSE 1 / curr.currency_rate_average_month
    END AS sales_invoice_line_group_cur_conso_avg_rate,
    CASE
        WHEN LineHomeCurrencyTotalAmount IS NULL OR LineHomeCurrencyTotalAmount = 0
            THEN 0
        ELSE LineHomeCurrencyTotalAmount / LineInvoiceCurrencyTotalAmount
    END AS sales_invoice_line_func_cur_rate,

    Company AS sales_invoice_line_company,
    InvoiceCurrency AS sales_invoice_line_transactional_currency_code,
    'USD' AS sales_invoice_line_group_currency_code,
    CONVERT(VARCHAR, NULL) AS sales_invoice_line_functional_currency_code,
    NULL AS sales_invoice_line_ledger_voucher,
    LineBU AS sales_invoice_line_business_unit,
    LineProductCode as sales_invoice_line_product_global_code,
    fsl.valid_from,
    fsl.valid_to,
    CASE 
        WHEN fsl.valid_to = '2999-12-31 23:59:59.999999' THEN 1 
        ELSE 0
    END AS is_current

FROM final_sales_lines fsl
LEFT JOIN {{ ref("currency_rate_mona") }} curr
    ON curr.currency_rate_currency_code = InvoiceCurrency
    AND FORMAT(TRY_CONVERT(DATETIME2(6), ClosureDate, 103), 'yyyyMM') = FORMAT(curr.currency_rate_closing_date, 'yyyyMM')

