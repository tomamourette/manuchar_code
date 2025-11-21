-- Auto Generated (Do not modify) BE544F12139572BC5D70528670004906194CAC539D831479FFDCBBC533C3164E
create view "cds"."sales_plan_dwh__dbt_temp__dbt_tmp_vw" as -- PLAN (BP2023)
WITH PlanData AS (
    SELECT DISTINCT
           CONCAT(
          COALESCE([Plan], ''), '_',
          COALESCE([Version], ''), '_',
          COALESCE(UPPER(TRIM(ab.CompanyCode)), ''), '_',
          COALESCE(TRIM([ProductCode]), ''), '_',
          COALESCE(TRIM([CustomerCode]), ''), '_',
          COALESCE([DestinationCountryCode], 
                  CONVERT(CHAR(10), EOMONTH(CAST(CAST(ab.MonthCode AS CHAR(6)) + '01' AS DATE)), 120))
      ) AS tkey_sales_plan,
        'Plan'                      AS [Category],
        'BP2023'                    AS [Plan],
        0                           AS [Version],
        UPPER(TRIM(ab.CompanyCode))            AS [Company],
        EOMONTH(CAST(CAST(ab.MonthCode AS CHAR(6)) + '01' AS DATE)) AS [ClosureDate],
        ISNULL(NULLIF(TRIM([CustomerCode]), ''), TRIM([CustomerCode])) AS [GroupCustomerID],
        ISNULL(NULLIF(TRIM([CustomerCode]), ''), cus.CustomerName) AS [GroupCustomerName],
        NULL                        AS [BusinessType],
        ab.DestinationCountryCode   AS [DestinationCountryCode], 
        NULL AS [DestinationCountry],
        TRIM([ProductCode])               AS [GroupProductID],
        p.ProductName               AS [GroupProductName],
        'MT'                        AS [UOM],
        CONVERT(FLOAT, ab.QuantityInMetricTon)          AS [Quantity],
        CONVERT(FLOAT, ab.SalesAmountGroupCurrency)     AS [GroupCurrencyTotalAmount],
        CONVERT(FLOAT, ab.COGSGroupCurrency)            AS [GroupCurrencyCOGS1Amount],
        CONVERT(FLOAT, ab.COGS2GroupCurrency)           AS [GroupCurrencyCOGS2Amount],
        NULL                        AS [HomeCurrency],
        CONVERT(FLOAT, ab.PlanRate) AS [PlanRate],
        ab.ingestion_timestamp
    FROM "dbb_warehouse"."ods"."sv_dwh_anaplan_budget" ab
    LEFT JOIN "dbb_warehouse"."ods"."sv_dwh_dim_customer"  cus ON CAST(cus.KDP_SK AS VARCHAR) = ab.FK_Customer
    LEFT JOIN "dbb_warehouse"."ods"."sv_dwh_dim_product"  p ON CAST(p.KDP_SK AS VARCHAR) = ab.FK_Product
    WHERE ab.[Plan] NOT IN ('BP Version 0','BP Version 1','BP Version 2','BP Version 3','BP Version 4')
    AND LEFT(ab.MonthCode, 4) = '2023' 
    AND ISNUMERIC(MonthCode) = 1
    AND LEN(MonthCode) = 6
    AND RIGHT(MonthCode, 2) BETWEEN '01' AND '12'
),

-- BUDGET 2024
Budget2024 AS (
    SELECT DISTINCT
          CONCAT(
          COALESCE([Plan], ''), '_',
          COALESCE([Version], ''), '_',
          COALESCE(UPPER(TRIM(ab.CompanyCode)), ''), '_',
          COALESCE(TRIM([ProductCode]), ''), '_',
          COALESCE(TRIM(cus.CustomerCode), ''), '_',
          COALESCE([DestinationCountryCode], 
                  CONVERT(CHAR(10), EOMONTH(CAST(CAST(ab.MonthCode AS CHAR(6)) + '01' AS DATE)), 120))
      ) AS tkey_sales_plan,
        'Budget'                    AS [Category],
        ab.[Plan],
        ab.Version,
        UPPER(TRIM(ab.CompanyCode))              AS [Company],
        EOMONTH(CAST(CAST(ab.MonthCode AS CHAR(6)) + '01' AS DATE)) AS [ClosureDate],
        ISNULL(NULLIF(TRIM(cus.CustomerCode), ''), TRIM(cus.CustomerCode)) AS [GroupCustomerID],
        ISNULL(NULLIF(TRIM(cus.CustomerCode), ''), cus.CustomerName) AS [GroupCustomerName],
        NULL                        AS [BusinessType],
        ab.DestinationCountryCode   AS [DestinationCountryCode], 
        NULL AS [DestinationCountry],
        TRIM([ProductCode])               AS [GroupProductID],
        p.ProductName               AS [GroupProductName],
        'MT'                        AS [UOM],
        CONVERT(FLOAT, ab.QuantityInMetricTon)          AS [Quantity],
        CONVERT(FLOAT, ab.SalesAmountGroupCurrency)     AS [GroupCurrencyTotalAmount],
        CONVERT(FLOAT, ab.COGSGroupCurrency)            AS [GroupCurrencyCOGS1Amount],
        CONVERT(FLOAT, ab.COGS2GroupCurrency)           AS [GroupCurrencyCOGS2Amount],
        NULL                        AS [HomeCurrency],
        CONVERT(FLOAT, ab.PlanRate) AS [PlanRate],
        ab.ingestion_timestamp
    FROM "dbb_warehouse"."ods"."sv_dwh_anaplan_budget" ab
    LEFT JOIN "dbb_warehouse"."ods"."sv_dwh_dim_customer"  cus ON CAST(cus.KDP_SK AS VARCHAR) = ab.FK_Customer
    LEFT JOIN "dbb_warehouse"."ods"."sv_dwh_dim_product"  p ON CAST(p.KDP_SK AS VARCHAR) = ab.FK_Product
    WHERE ab.[Plan] NOT IN ('BP Version 0','BP Version 1','BP Version 2','BP Version 3','BP Version 4')
    AND LEFT(ab.MonthCode, 4) = '2024'
    AND ISNUMERIC(MonthCode) = 1
    AND LEN(MonthCode) = 6
    AND RIGHT(MonthCode, 2) BETWEEN '01' AND '12'
),

-- BUDGET (generic)
BudgetOther AS (
    SELECT DISTINCT
             CONCAT(
          COALESCE([Plan], ''), '_',
          COALESCE([Version], ''), '_',
          COALESCE(UPPER(TRIM(ab.CompanyCode)), ''), '_',
          COALESCE(TRIM([ProductCode]), ''), '_',
          COALESCE(TRIM(cus.CustomerCode), ''), '_',
          COALESCE([DestinationCountryCode], 
                  CONVERT(CHAR(10), EOMONTH(CAST(CAST(ab.MonthCode AS CHAR(6)) + '01' AS DATE)), 120))
      ) AS tkey_sales_plan,
        'Budget'                    AS [Category],
        ab.[Plan],
        ab.Version,
        UPPER(TRIM(ab.CompanyCode))             AS [Company],
        EOMONTH(CAST(CAST(ab.MonthCode AS CHAR(6)) + '01' AS DATE)) AS [ClosureDate],
        ISNULL(NULLIF(TRIM(cus.CustomerCode), ''), TRIM(cus.CustomerCode)) AS [GroupCustomerID],
        ISNULL(NULLIF(TRIM(cus.CustomerCode), ''), cus.CustomerName) AS [GroupCustomerName],
        NULL                        AS [BusinessType],
        ab.DestinationCountryCode   AS [DestinationCountryCode], 
        NULL AS [DestinationCountry],
        TRIM([ProductCode])               AS [GroupProductID],
        p.ProductName               AS [GroupProductName],
        'MT'                        AS [UOM],
        CONVERT(FLOAT, ab.QuantityInMetricTon)          AS [Quantity],
        CONVERT(FLOAT, ab.SalesAmountGroupCurrency)     AS [GroupCurrencyTotalAmount],
        CONVERT(FLOAT, ab.COGSGroupCurrency)            AS [GroupCurrencyCOGS1Amount],
        CONVERT(FLOAT, ab.COGS2GroupCurrency)           AS [GroupCurrencyCOGS2Amount],
        NULL                        AS [HomeCurrency],
        CONVERT(FLOAT, ab.PlanRate) AS [PlanRate],
        ab.ingestion_timestamp
    FROM "dbb_warehouse"."ods"."sv_dwh_dbo_anaplan_budget" ab
    LEFT JOIN "dbb_warehouse"."ods"."sv_dwh_dim_customer"  cus ON CAST(cus.KDP_SK AS VARCHAR) = ab.FK_Customer
    LEFT JOIN "dbb_warehouse"."ods"."sv_dwh_dim_product"  p ON CAST(p.KDP_SK AS VARCHAR) = ab.FK_Product
    WHERE ISNUMERIC(MonthCode) = 1
    AND LEN(MonthCode) = 6
    AND RIGHT(MonthCode, 2) BETWEEN '01' AND '12'
),

-- FORECAST
Forecast AS (
    SELECT DISTINCT
             CONCAT(
          COALESCE([Plan], ''), '_',
          COALESCE([Version], ''), '_',
          COALESCE(UPPER(TRIM(af.CompanyCode)), ''), '_',
          COALESCE(TRIM([ProductCode]), ''), '_',
          COALESCE(TRIM(cus.CustomerCode), ''), '_',
          COALESCE([DestinationCountryCode], 
        CONVERT(CHAR(10), EOMONTH(CAST(CAST(af.MonthCode AS CHAR(6)) + '01' AS DATE)), 120))
      ) AS tkey_sales_plan,
        'Forecast'                  AS [Category],
        af.[Plan],
        af.Version,
        UPPER(TRIM(af.CompanyCode))             AS [Company],
        EOMONTH(CAST(CAST(af.MonthCode AS CHAR(6)) + '01' AS DATE)) AS [ClosureDate],
        ISNULL(NULLIF(TRIM(cus.CustomerCode), ''), TRIM(cus.CustomerCode)) AS [GroupCustomerID],
        ISNULL(NULLIF(TRIM(cus.CustomerCode), ''), cus.CustomerName) AS [GroupCustomerName],
        NULL                        AS [BusinessType],
        af.DestinationCountryCode   AS [DestinationCountryCode], 
        NULL AS [DestinationCountry],
        TRIM([ProductCode])               AS [GroupProductID],
        p.ProductName               AS [GroupProductName],
        'MT'                        AS [UOM],
        CONVERT(FLOAT, af.QuantityInMetricTon)          AS [Quantity],
        CONVERT(FLOAT, af.SalesAmountGroupCurrency)     AS [GroupCurrencyTotalAmount],
        CONVERT(FLOAT, af.COGSGroupCurrency)            AS [GroupCurrencyCOGS1Amount],
        CONVERT(FLOAT, af.COGS2GroupCurrency)           AS [GroupCurrencyCOGS2Amount],
        NULL                        AS [HomeCurrency],
        CONVERT(FLOAT, af.PlanRate) AS [PlanRate],
        af.ingestion_timestamp
    FROM "dbb_warehouse"."ods"."sv_dwh_anaplan_forecast" af
    LEFT JOIN "dbb_warehouse"."ods"."sv_dwh_dim_customer"  cus ON CAST(cus.KDP_SK AS VARCHAR) = af.FK_Customer
    LEFT JOIN "dbb_warehouse"."ods"."sv_dwh_dim_product"  p ON CAST(p.KDP_SK AS VARCHAR) = af.FK_Product
    WHERE ISNUMERIC(MonthCode) = 1
    AND LEN(MonthCode) = 6
    AND RIGHT(MonthCode, 2) BETWEEN '01' AND '12'
),

SALES_PLAN_STG_PRODUCT_FIX_1 AS (
SELECT DISTINCT
    CONCAT(
            COALESCE([Plan], ''), '_',
            COALESCE([Version], ''), '_',
            COALESCE(UPPER(TRIM([Company])), ''), '_',
            COALESCE(TRIM([GroupProductID]), ''), '_',
            COALESCE(TRIM([GroupCustomerID]), ''), '_',
            COALESCE([DestinationCountry], '') ,'_',
            COALESCE([CLosureDate], '')
        ) AS tkey_sales_plan,
    [Category],
    [Plan],
    [Version],
    UPPER(TRIM([Company])) AS [Company],
    [CLosureDate],
    TRIM([GroupCustomerID]) AS [GroupCustomerID],
    [GroupCustomerName],
    [BusinessType],
    cou.Code AS [DestinationCountryCode],
    [DestinationCountry],
    TRIM([GroupProductID]) AS [GroupProductID],
  --  [KDP_loadDT],
    LEFT([GroupProductName], CHARINDEX('_FIX0', [GroupProductName]) - 1) AS [GroupProductName],
    [UOM],
    SUM([Quantity]) AS [Quantity],
    SUM([GroupCurrencyTotalAmount]) AS [GroupCurrencyTotalAmount],
    SUM([GroupCurrencyCOGS1Amount]) AS [GroupCurrencyCOGS1Amount],
    SUM([GroupCurrencyCOGS2Amount]) AS [GroupCurrencyCOGS2Amount],
    [HomeCurrency],
    [PlanRate],
    sh.ingestion_timestamp
FROM  "dbb_warehouse"."ods"."sv_dwh_stg_sales_plan_hist" sh   
LEFT JOIN "dbb_warehouse"."ods"."sv_mds_countries" cou
	ON cou.Name = [DestinationCountry]
WHERE   ProductFix = 1 
GROUP BY  
    [Category],
    [Plan],
    [Version],
    [Company],
    [CLosureDate],
    [GroupCustomerID],
    [GroupCustomerName],
    [BusinessType],
    cou.Code,
    [DestinationCountry],
    [GroupProductID],
   -- [KDP_loadDT],
    LEFT([GroupProductName], CHARINDEX('_FIX0', [GroupProductName]) - 1),
    [UOM],
    [HomeCurrency],
    [PlanRate],
    sh.ingestion_timestamp
),

SALES_PLAN_STG_PRODUCT_FIX_0 AS (

SELECT DISTINCT
    CONCAT(
            COALESCE([Plan], ''), '_',
            COALESCE([Version], ''), '_',
            COALESCE(UPPER(TRIM([Company])), ''), '_',
            COALESCE(TRIM([GroupProductID]), ''), '_',
            COALESCE(TRIM([GroupCustomerID]), ''), '_',
            COALESCE([DestinationCountry], '') ,'_',
            COALESCE([CLosureDate], '')
        ) AS tkey_sales_plan,
    [Category],
    [Plan],
    [Version],
    UPPER(TRIM([Company])) AS [Company],
    [CLosureDate],
    TRIM([GroupCustomerID]) AS [GroupCustomerID],
    [GroupCustomerName],
    [BusinessType],
    cou.Code AS [DestinationCountryCode],
    [DestinationCountry],
    TRIM([GroupProductID]) AS [GroupProductID],
    [GroupProductName],
    [UOM],
    [Quantity],
    [GroupCurrencyTotalAmount],
    [GroupCurrencyCOGS1Amount],
    [GroupCurrencyCOGS2Amount],
    [HomeCurrency],
    [PlanRate],
    sh.ingestion_timestamp
FROM   "dbb_warehouse"."ods"."sv_dwh_stg_sales_plan_hist" sh
LEFT JOIN "dbb_warehouse"."ods"."sv_mds_countries" cou
	ON cou.Name = [DestinationCountry]
WHERE 
    ProductFix = 0),

CombinedSalesPlan AS (
    SELECT * FROM PlanData
    UNION
    SELECT * FROM Budget2024
    UNION
    SELECT * FROM BudgetOther
    UNION
    SELECT * FROM Forecast
    UNION
    SELECT * FROM SALES_PLAN_STG_PRODUCT_FIX_1
    UNION
    SELECT * FROM SALES_PLAN_STG_PRODUCT_FIX_0
),

SalesPlanWithValidity AS (
    SELECT
        *,
        ingestion_timestamp AS valid_from,
        COALESCE(LEAD(ingestion_timestamp) OVER (
            PARTITION BY tkey_sales_plan
            ORDER BY ingestion_timestamp
        ),'2999-12-31 23:59:59.999999') AS valid_to
    FROM CombinedSalesPlan
),

RankedSalesPlan AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY [Company], [ClosureDate], [GroupCustomerID], [GroupProductID], [Plan] ,[Version]
            ORDER BY [ClosureDate]
        ) AS rn
    FROM SalesPlanWithValidity
)

    SELECT 
        CONCAT(tkey_sales_plan,'_',sh.rn) AS bkey_sales_plan,
        CONCAT(sh.[tkey_sales_plan], '_DWH') AS bkey_sales_plan_source,
        sh.rn AS sales_plan_budget_line_number,
        'DWH' as bkey_source,
        sh.[Category] AS sales_plan_category,
        sh.[Plan] AS sales_plan_plan,
        sh.[Version] AS sales_plan_version,
        sh.[Company] AS sales_plan_company,
        sh.[ClosureDate] AS sales_plan_closure_date,
        TRIM(sh.[GroupCustomerID]) AS sales_plan_global_customer_code,
        TRIM(cus.Customer_ID) AS sales_plan_customer_id,
        cgk.Name AS sales_plan_customer_name,
        sh.[BusinessType] AS sales_plan_business_type,
        sh.[GroupProductID] AS sales_plan_product_global_code,
        p.[Name] AS sales_plan_poduct_global_name,
        sh.[UOM] AS sales_plan_uom,
        sh.[Quantity] AS sales_plan_quantity,
        CONVERT(DECIMAL(38,5), sh.[Quantity] / uom.[ConversionToMT]) AS sales_plan_quantity_metric_ton,

        sh.[GroupCurrencyTotalAmount] AS sales_plan_group_currency_total_amount,
        ROUND(ISNULL(sh.[GroupCurrencyTotalAmount], 0.0),6) / NULLIF(sh.[PlanRate], 0) AS  sales_plan_home_currency_total_amount,
        CONVERT(DECIMAL(38,5), sh.[GroupCurrencyTotalAmount] /NULLIF(sh.[PlanRate], 0)) AS  sales_plan_budget_currency_total_amount,

        sh.[GroupCurrencyCOGS1Amount] AS sales_plan_group_currency_cogs1_amount,
        ROUND(ISNULL(sh.[GroupCurrencyCOGS1Amount], 0.0),6) / NULLIF(sh.[PlanRate], 0) AS  sales_plan_home_currency_cogs1_amount,
        CONVERT(DECIMAL(38,5), sh.[GroupCurrencyCOGS1Amount] /NULLIF(sh.[PlanRate], 0)) AS  sales_plan_budget_currency_cogs1_amount,

        sh.[GroupCurrencyCOGS2Amount] AS sales_plan_group_currency_cogs2_amount,
        ROUND(ISNULL(sh.[GroupCurrencyCOGS2Amount], 0.0),6) / NULLIF(sh.[PlanRate], 0) AS  sales_plan_home_currency_cogs2_amount,
        CONVERT(DECIMAL(38,5), sh.[GroupCurrencyCOGS2Amount] /NULLIF(sh.[PlanRate], 0)) AS  sales_plan_budget_currency_cogs2_amount,

        sh.[HomeCurrency] AS sales_plan_home_currency,
        sh.[PlanRate] AS sales_plan_plan_rate,
        ite.[Industry_Type_Code] AS sales_plan_industry_type_code,
        cgk.[Code] AS sales_plan_customer_code_cgk,
        sh.DestinationCountryCode AS sales_plan_destination_country,
        ts14m_46.[InfoText] AS sales_plan_currency,
        sh.valid_from,
        sh.valid_to,
        CASE 
            WHEN sh.valid_to = '2999-12-31 23:59:59.999999' THEN 1 
            ELSE 0
        END AS is_current

    FROM RankedSalesPlan sh
    LEFT JOIN "dbb_warehouse"."ods"."sv_mds_customergoldenkey" cgk 
        ON sh.[GroupCustomerID] = cgk.[Code]
        AND cgk.[ValidationStatus] = 'Validation Succeeded'    
    LEFT JOIN (
        SELECT 
            ctm.Company_Name_Code, 
            cm.Customer_Golden_Key_Code,
            ctm.Customer_ID
        FROM "dbb_warehouse"."ods"."sv_mds_customermapping" cm 
        LEFT JOIN "dbb_warehouse"."ods"."sv_mds_customertomap" ctm
            ON ctm.Code = cm.Customer_To_Map_Code
            AND ctm.ValidationStatus = 'Validation Succeeded'
    ) cus 
    ON cus.Company_Name_Code = sh.Company 
    AND cus.Customer_Golden_Key_Code = cgk.Code
    LEFT JOIN "dbb_warehouse"."ods"."sv_mds_industrytypesexceptions" ite
        ON sh.[GroupCustomerID] = ite.[Customer_Golden_Key_Code]
        AND sh.[GroupProductID] = ite.[Product_Code]
    LEFT JOIN "dbb_warehouse"."ods"."sv_mds_product" p 
        ON sh.[GroupProductID] = p.[Code] 
    LEFT JOIN "dbb_warehouse"."ods"."sv_mds_uom" uom
        ON sh.[UOM] = uom.[Code]
    LEFT JOIN "dbb_warehouse"."ods"."sv_mona_ts014c0" ts14c
        ON sh.[Company] = ts14c.[CompanyCode]
        AND ts14c.[ConsoID] = 29422
    LEFT JOIN "dbb_warehouse"."ods"."sv_mona_ts014m1" ts14m
        ON ts14c.[CompanyID] = ts14m.[CompanyID]
        AND ts14m.[ConsoID] = 29422
        AND ts14m.[AddInfoID] = 45
    LEFT JOIN "dbb_warehouse"."ods"."sv_mona_ts014m1" ts14m_46
        ON ts14c.[CompanyID] = ts14m_46.[CompanyID]
        AND ts14m_46.[ConsoID] = 29422
        AND ts14m_46.[AddInfoID] = 46
    WHERE sh.rn = 1;