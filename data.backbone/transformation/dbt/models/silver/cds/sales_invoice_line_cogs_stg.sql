WITH staging_sales AS (
    SELECT 
        InvoiceID,  
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
        CAST(sh.LineQuantity AS DECIMAL(38, 5)) AS Quantity,CAST(sh.LineQuantity AS DECIMAL(38, 5))/ uom.[ConversionToMT] AS [QuantityInMetricTon],
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
)
,

main_sales AS (
    SELECT *
    FROM staging_sales
    WHERE CAST(LineInvoiceCurrencyTotalAmount AS DECIMAL(18,4)) <> 0
),

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

main_line_aggregates AS (
    SELECT 
        InvoiceID,
        Company,
        InvoiceLineNum,
        LineProductID,
        MAX(Product_Code) AS LineProductCode,
        MAX(Product_Business_Unit_Name) AS LineBU,
        MAX(LineProductName) AS LineProductName,
        SUM(CAST(LineQuantity AS DECIMAL(18,2))) AS LineQuantity,
        SUM(QuantityInMetricTon) AS LineQuantityMT,
        MIN(LineUOM) AS LineUOM,
        SUM(CAST(LineInvoiceCurrencyTotalAmount AS DECIMAL(18,4))) AS LineInvoiceCurrencyTotalAmount,
        SUM(CAST(LineHomeCurrencyTotalAmount AS DECIMAL(18,4))) AS LineHomeCurrencyTotalAmount,
        MIN(InvoiceCurrency) AS InvoiceCurrency,
        MIN(valid_from) AS valid_from,
        MAX(valid_to) AS valid_to
    FROM main_deduped_with_validity
    GROUP BY InvoiceID, Company, InvoiceLineNum, LineProductID
)
,

supporting_aggregates AS (
    SELECT 
        CASE 
            WHEN Company = 'MNV' AND LEN(InvoiceID) > 2 THEN LEFT(InvoiceID, LEN(InvoiceID) - 2)
            ELSE InvoiceID
        END AS BaseInvoiceID,
        Company,
        LineProductID,
        SUM(CAST(LineHomeCurrencyCOGSAmount AS DECIMAL(18,4))) AS total_cogs,
        SUM(CAST(LineHomeCurrencyExternalTransportAmount AS DECIMAL(18,4))) AS total_external_transport,
        SUM(CAST(LineHomeCurrencyInternalTransportAmount AS DECIMAL(18,4))) AS total_internal_transport,
        SUM(CAST(LineHomeCurrencyOtherCOGS2Amount AS DECIMAL(18,4))) AS total_other_cogs2
    FROM staging_sales 
    GROUP BY 
        CASE 
            WHEN Company = 'MNV'  AND LEN(InvoiceID) > 2 THEN LEFT(InvoiceID, LEN(InvoiceID) - 2)
            ELSE InvoiceID
        END,
        Company,
        LineProductID
)
,

final_sales_lines AS (
    SELECT 
        m.*,
        COALESCE(s.total_cogs, 0) AS support_total_cogs,
        COALESCE(s.total_external_transport, 0) AS support_total_external_transport,
        COALESCE(s.total_internal_transport, 0) AS support_total_internal_transport,
        COALESCE(s.total_other_cogs2, 0) AS support_total_other_cogs2
    FROM main_line_aggregates m 
    LEFT JOIN supporting_aggregates s 
        ON s.Company = m.Company
        AND s.LineProductID = m.LineProductID
        AND 
        	(
    (s.Company = 'MNV' AND 
     CASE 
         WHEN m.InvoiceID IS NOT NULL AND LEN(m.InvoiceID) > 2 
         THEN LEFT(m.InvoiceID, LEN(m.InvoiceID) - 2) 
         ELSE m.InvoiceID
     END = s.BaseInvoiceID) OR

    (s.Company <> 'MNV' AND m.InvoiceID = s.BaseInvoiceID)
)

)

SELECT 
    InvoiceID + '_' + CAST(InvoiceLineNum AS VARCHAR) + '_' + Company + '_STG_SALES' AS bkey_sales_invoice_line_cogs_source,
    InvoiceID + '_' + CAST(InvoiceLineNum AS VARCHAR) + '_' + Company AS bkey_sales_invoice_line_cogs,
    InvoiceID + '_' + Company AS bkey_sales_invoice,
    'STG_SALES' AS bkey_source,
    Company AS sales_invoice_line_cogs_company,
    InvoiceID AS sales_invoice_line_cogs_invoice_id,
    InvoiceLineNum AS sales_invoice_line_cogs_line_num,
    
    --LineProductName AS sales_invoice_line_product_name,
    LineQuantity AS sales_invoice_line_cogs_quantity,
    LineUOM AS sales_invoice_line_cogs_uom,
    InvoiceCurrency AS sales_invoice_line_cogs_currency_code,
    LineProductCode AS sales_invoice_line_product_id,
    LineInvoiceCurrencyTotalAmount AS csv_sales_amount_m_local,
    LineHomeCurrencyTotalAmount AS csv_sales_amount_m_home,
    NULL AS erp_sales_amount_m_local,
    NULL AS erp_sales_amount_m_home,
    NULL AS erp_cost_amount_posted,
 
    -- New Dynamics COGS columns
    NULL AS erp_cogs1_purchase_amount_m_local,
    NULL AS erp_cogs1_purchase_amount_m_local_currency,
    NULL AS erp_cogs1_purchase_amount_m_home,
    NULL AS erp_cogs1_purchase_amount_m_group,

    NULL AS erp_cogs1_freight_amount_m_local,
    NULL AS erp_cogs1_freight_amount_m_local_currency,
    NULL AS erp_cogs1_freight_amount_m_home,
    NULL AS erp_cogs1_freight_amount_m_group,

    NULL AS erp_cogs1_other_amount_m_local,
    NULL AS erp_cogs1_other_amount_m_local_currency,
    NULL AS erp_cogs1_other_amount_m_home,
    NULL AS erp_cogs1_other_amount_m_group,

    NULL AS erp_cogs1_amount_m_local,
    NULL AS erp_cogs1_amount_m_local_currency,
    NULL AS erp_cogs1_amount_m_home,
    NULL AS erp_cogs1_amount_m_group,

    NULL AS erp_cogs2_internal_transport_amount_m_local,
    NULL AS erp_cogs2_internal_transport_amount_m_local_currency,
    NULL AS erp_cogs2_internal_transport_amount_m_home,
    NULL AS erp_cogs2_internal_transport_amount_m_group,

    NULL AS erp_cogs2_external_transport_amount_m_local,
    NULL AS erp_cogs2_external_transport_amount_m_local_currency,
    NULL AS erp_cogs2_external_transport_amount_m_home,
    NULL AS erp_cogs2_external_transport_amount_m_group,

    NULL AS erp_cogs2_other_amount_m_local,
    NULL AS erp_cogs2_other_amount_m_local_currency,
    NULL AS erp_cogs2_other_amount_m_home,
    NULL AS erp_cogs2_other_amount_m_group,
    
    -- New STG COGS column
    COALESCE(support_total_cogs, 0) AS  csv_cogs1_amount,
    COALESCE(support_total_external_transport, 0) AS csv_external_transport_amount,
    COALESCE(support_total_internal_transport, 0) AS csv_internal_transport_amount,
    COALESCE(support_total_other_cogs2, 0) AS csv_other_cogs2_amount,
    COALESCE(support_total_external_transport + support_total_internal_transport + support_total_other_cogs2, 0) AS csv_cogs2_amount,

    valid_from,
    valid_to,
    CASE 
        WHEN valid_to = '2999-12-31 23:59:59.999999' THEN 1 
        ELSE 0
    END AS is_current
FROM final_sales_lines;
