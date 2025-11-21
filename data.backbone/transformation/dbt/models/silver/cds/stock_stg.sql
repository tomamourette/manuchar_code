WITH stock_stg AS (
    SELECT
        CONCAT(TRIM(Company), '_', TRIM(sh.ClosureDate), '_', TRIM(EntryDate), '_', TRIM(WarehouseName), '_', TRIM(LotNumber), '_', TRIM(ProductID), '_', TRIM(Quantity), '_', TRIM(HomeCurrencyInventoryCostAmount), '_', TRIM([Committed]), '_STG_STOCK') AS bkey_stock_source,
        CONCAT(TRIM(Company), '_', TRIM(sh.ClosureDate), '_', TRIM(EntryDate), '_', TRIM(WarehouseName), '_', TRIM(LotNumber), '_', TRIM(ProductID), '_', TRIM(Quantity), '_', TRIM(HomeCurrencyInventoryCostAmount), '_', TRIM([Committed])) AS bkey_stock,
        'STG_STOCK' AS bkey_source,
        sh.Company,
        COALESCE(comh.Value, ts014m.InfoText) AS CurrencyCode,
        sh.ClosureDate,
        sh.EntryDate,
        sh.WarehouseName,
        sh.LotNumber,
        pam.Product_Code,
        sh.ProductID,
        sh.Quantity,
        CAST(sh.Quantity AS DECIMAL) / uom.ConversionToMT AS QuantityInMT, 
        sh.UOM,
        sh.HomeCurrencyInventoryCostAmount AS stock_amount_func_cur,
        sh.HomeCurrencyInventoryCostAmount / curr.currency_rate_closing_rate AS stock_amount_group_conso_eom, 
        NULL AS stock_amount_group_oanda_eod,
        CASE WHEN sh.Committed IN ('YES', 'Y', 'S') THEN 1 ELSE 0 END AS [Committed],
        CASE WHEN sh.WarehouseName IN ('IN TRANSIT', 'TRANSITO', 'WATER') THEN 1 ELSE 0 END AS stock_in_transit,
        sh.FileName,
        CAST(sh.ingestion_timestamp AS DATETIME2(6)) AS valid_from,
        COALESCE(CAST(LEAD(sh.ingestion_timestamp) OVER (PARTITION BY CONCAT(TRIM(Company), '_', TRIM(sh.ClosureDate), '_', TRIM(EntryDate), '_', TRIM(WarehouseName), '_', TRIM(LotNumber), '_', TRIM(ProductID), '_', TRIM(Quantity), '_', TRIM(HomeCurrencyInventoryCostAmount), '_', TRIM([Committed])) ORDER BY sh.ingestion_timestamp) AS DATETIME2(6)),'2999-12-31 23:59:59.999999') AS valid_to
    FROM {{ ref('sv_stg_stg_stock_hist') }} sh
    INNER JOIN {{ ref('sv_log_validationapprovallog') }} val
        ON sh.Company = val.CompanyCode
        AND sh.ClosureDate = val.ClosureDate
        AND sh.FileName = val.FileName
        AND val.Status = 'APPROVED'
    LEFT JOIN {{ ref('sv_mds_productaffiliatemapping') }} pam
        ON CONCAT(sh.Company, ' - ', sh.ProductID) = pam.Code
    LEFT JOIN {{ ref('sv_mona_ts014c0') }} ts14c
            ON sh.Company = ts14c.CompanyCode
            AND ts14c.ConsoID = 29422
    LEFT JOIN {{ ref('sv_mona_ts014m1') }} ts014m
        ON ts014m.CompanyID = ts14c.CompanyID
        AND ts014m.ConsoID = 29422
        AND ts014m.AddInfoID = 46
    LEFT JOIN {{ ref('sv_mds_companyhistory') }} comh
        ON sh.Company = comh.Company_Code
        AND CONVERT(DATETIME2(6), CONVERT(VARCHAR, sh.ClosureDate), 103) BETWEEN comh.[Start_Date] AND comh.[End_Date]
        AND comh.[Key] = 'Home Currency'
    LEFT JOIN {{ ref('sv_mds_uommapping') }} uoma
        ON TRIM(sh.Company) = uoma.Company_Code 
        AND sh.UOM = uoma.Local_UOM_Code 
        AND uoma.ValidationStatus = 'Validation Succeeded'
    LEFT JOIN {{ ref('sv_mds_uom') }} uom 
        ON uom.Code = uoma.Group_UOM_Code_Code
    LEFT JOIN {{ ref("currency_rate_mona") }} curr
        ON curr.currency_rate_currency_code = COALESCE(comh.Value, ts014m.InfoText)
        AND FORMAT(TRY_CONVERT(DATETIME2(6), sh.ClosureDate, 103), 'yyyyMM') = FORMAT(curr.currency_rate_closing_date, 'yyyyMM')
    WHERE 
        TRY_CONVERT(DATETIME2(6), sh.ClosureDate, 103) IS NOT NULL
)

SELECT
    bkey_stock_source,
    bkey_stock,
    bkey_source,
    Company AS stock_company,
    NULL AS stock_customer_id,
    CurrencyCode AS stock_currency,
    ClosureDate AS stock_closure_date,
    EntryDate AS stock_entry_date,
    WarehouseName AS stock_warehouse_name,
    NULL AS stock_invent_location_id,
    NULL AS stock_site_id,
    LotNumber AS stock_lot_number,
    Product_Code AS stock_product_code,
    ProductID AS stock_product_id,
    Quantity AS stock_quantity,
    QuantityInMT AS stock_quantity_mt,
    UOM AS stock_uom,
    stock_amount_func_cur,
    stock_amount_group_conso_eom,
    stock_amount_group_oanda_eod,
    [Committed] AS stock_committed,
    stock_in_transit,
    [FileName] AS stock_file_name,
    valid_from,
    valid_to,
    CASE 
        WHEN valid_to = '2999-12-31 23:59:59.999999' THEN 1 
        ELSE 0
    END AS is_current
FROM stock_stg

