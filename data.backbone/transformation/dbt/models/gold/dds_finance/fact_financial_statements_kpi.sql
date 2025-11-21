{{ config(
    tags=['Group-FinancialStatements', 'Fact', 'Fact Financial Statements KPI']
) }}

-- Step 1: Define KPI Mappings for various financial metrics
WITH KPI_Mapping AS (
    SELECT 'Turnover' AS KPI_Name, 'Turnover' AS AHL1, NULL AS AHL2, NULL AS BKEY_Account, NULL AS AHL3, NULL AS Account_Description
    UNION ALL
    SELECT 'Sales volume (MT)2', NULL, NULL, '700001QMT', NULL, NULL
    UNION ALL
    SELECT 'Sales volume (MT)1', NULL, NULL, '700000QMT', NULL, NULL
    UNION ALL
    SELECT 'COGS1', 'Cost of Good Sold', NULL, NULL, NULL, NULL
    UNION ALL
    SELECT 'COGS2', 'Gross Margin 2 Expenses', NULL, NULL, NULL, NULL
    UNION ALL
    SELECT 'Transactional financing cost', 'Gross Margin 2 Expenses Adjusted', 'Financing', NULL, NULL, NULL
    UNION ALL
    SELECT 'Transactional financing cost', 'Gross Margin 2 Expenses Adjusted', 'Other Financial Results', NULL, NULL, NULL
    UNION ALL
    SELECT 'Realized FX on Natural Hedge', 'Gross Margin 2 Expenses Adjusted', 'Realized Forex', NULL, NULL, NULL
    UNION ALL
    SELECT 'Other Income', 'Other Income', NULL, NULL, NULL, NULL        
    UNION ALL
    SELECT 'Overheads', 'Overheads', NULL, NULL, NULL, NULL
    UNION ALL
    SELECT 'Recharges', NULL, NULL, '610619', NULL, NULL
    UNION ALL
    SELECT 'Recharges', NULL, NULL, '930611', NULL, NULL
    UNION ALL
    SELECT 'Recharges', NULL, NULL, '930619', NULL, NULL
    UNION ALL
    SELECT 'Depreciations and Amortizations', 'Depreciations and Amortizations', NULL, NULL,NULL,NULL
    UNION ALL
    SELECT 'Forex', 'Forex', NULL, NULL, NULL, NULL
    UNION ALL
    SELECT 'Unrealized FX', NULL, 'Unrealized Forex', NULL, NULL, NULL
    UNION ALL
    SELECT 'Financing result', 'Financing', NULL, NULL, NULL, NULL
    UNION ALL
    SELECT 'Financing result', NULL, NULL, '750100', NULL,NULL
    UNION ALL
    SELECT 'Banking costs', 'Other Financial Results', NULL, NULL, NULL, NULL
    UNION ALL
    SELECT 'Non-Recurring Other', 'Non-recurring', NULL, NULL, NULL, NULL
    UNION ALL
    SELECT 'Taxes', 'Tax', NULL, NULL, NULL, NULL  
    UNION ALL
    SELECT 'Long Term Assets', NULL, 'Fixed Assets', NULL, NULL, NULL
    UNION ALL
    SELECT 'Long Term Assets', NULL, 'Long Term Receivables', NULL, NULL, NULL
    UNION ALL
    SELECT 'Stocks', NULL, NULL, NULL, 'Stocks and contracts in progress', NULL
    UNION ALL
    SELECT 'Accounts Receivable', NULL, NULL, NULL, 'Trade Debtors', NULL
    UNION ALL
    SELECT 'Accounts Receivable', NULL, NULL, NULL, 'Other Amounts Receivable', NULL
    UNION ALL
    SELECT 'Accounts Receivable', NULL, NULL, NULL, 'Deferred charges and accrued income', NULL
    UNION ALL
    SELECT 'Accounts Payable', NULL, NULL, NULL, 'Trade Payables', NULL
    UNION ALL
    SELECT 'Accounts Payable', NULL, NULL, NULL, 'Other amounts Payable', NULL
    -- UNION ALL
    -- SELECT 'ICO ACT', NULL, NULL, '440090', NULL, NULL
    UNION ALL
    SELECT 'Equity (incl. minorities)', NULL, 'Equity', NULL, NULL, NULL
    UNION ALL
    SELECT 'Equity (incl. minorities)', NULL, 'Minority Interests', NULL, NULL, NULL
    UNION ALL
    SELECT 'Provisions', NULL, 'Provisions, Deferred Taxes & Other LT Liabilities', NULL, NULL, NULL
    UNION ALL
    SELECT 'External financial debt', NULL, NULL, NULL, 'Short Term Financial Debts', NULL
    UNION ALL
    SELECT 'External financial debt', NULL, NULL, NULL, 'Long Term Debts', NULL
    UNION ALL
    SELECT 'External financial debt', NULL,NULL, NULL, 'Current portion of LT Debts', NULL
    UNION ALL
    SELECT 'Debt from historical allocations', NULL,NULL, '839999', NULL, NULL
    UNION ALL
    SELECT 'IC loans and accounts payable', NULL,NULL, NULL, 'Intercompany Payables / Receivables', NULL
    UNION ALL
    SELECT 'Cash', NULL,NULL, NULL, 'X. Cash at bank and in hand', NULL
    UNION ALL
    SELECT 'Cash', NULL,NULL, NULL, 'IX. Investments', NULL
    UNION ALL
    SELECT 'Working Capital', NULL,'Working Capital', NULL, NULL, NULL
    -- UNION ALL
    -- SELECT 'ICO BUD', NULL, NULL, NULL, 'Trade Payables', NULL
    -- UNION ALL
    -- SELECT 'ICO BUD', NULL, NULL, NULL, 'Other amounts Payable', NULL
    UNION ALL
    SELECT 'Transactional ST debt', NULL,  NULL, '426010',  NULL, NULL
    UNION ALL
    SELECT 'Transactional ST debt', NULL,  NULL, '430010',  NULL, NULL
    UNION ALL
    SELECT 'Capital Employed', 'Capital Employed',  NULL, NULL,  NULL, NULL
    UNION ALL
    SELECT 'Capital Invested', 'Capital Invested',  NULL, NULL,  NULL, NULL
    UNION ALL
    SELECT 'Trade Payables', NULL,  NULL, NULL,  'Trade Payables', NULL
    UNION ALL
    SELECT 'Trade Debtors', NULL,  NULL, NULL, 'Trade Debtors', NULL
),
 
-- Step 2: Aggregate base KPI data from fact and dimension table
Base_KPI AS (
    SELECT
        kpi.KPI_Name,
        REPLACE(CONVERT(DATE, CONVERT(VARCHAR(8), ffs.tkey_date)), '-', '') AS tkey_date,
        ffs.tkey_company,
        dcom.company_code,
        ffs.tkey_consolidation_period,
        replace(dco.consolidation_category,'BGAAP','ACT') as consolidation_category,
        dco.consolidation_version,
        dco.consolidation_scope,
        dco.consolidation_L4L_scope,
        dco.consolidation_code,
        dat.year as yearvalue,

        -- Actuals: sum bundle amounts and volume amounts based on conditions
        SUM(CASE
                WHEN (dco.consolidation_category = 'ACT'
               
                    or (dco.consolidation_category = 'BGAAP' and TRY_CAST(dat.year AS INT) < 2024 ))
                     AND dco.consolidation_version = 0
                     AND kpi.KPI_Name <> 'Sales volume (MT)1'
                     AND kpi.KPI_Name <> 'Sales volume (MT)2'
                    --AND kpi.KPI_Name <> 'ICO BUD'
                    THEN ffs.bundle_amount * dacc.account_reporting_sign
         
 
               
                WHEN  (dco.consolidation_category = 'ACT'
               
                    or (dco.consolidation_category = 'BGAAP' and TRY_CAST(dat.year AS INT) < 2024 ))
                     AND dco.consolidation_version = 0
                     AND kpi.KPI_Name =  'Sales volume (MT)1'
                THEN ffs.volume_amount


                WHEN (dco.consolidation_category = 'ACT'
               
                    or (dco.consolidation_category = 'BGAAP' and TRY_CAST(dat.year AS INT) < 2024 ))
                     AND dco.consolidation_version = 0
                     AND kpi.KPI_Name =  'Sales volume (MT)2'
                THEN ffs.volume_amount * -1
                ELSE
                 0
            END) AS ytd_bundle_amount_act,
        SUM(CASE
                WHEN (dco.consolidation_category = 'ACT'
               
                    or (dco.consolidation_category = 'BGAAP' and TRY_CAST(dat.year AS INT) < 2024 ))
                     AND dco.consolidation_version = 0
                     AND kpi.KPI_Name <> 'Sales volume (MT)1'
                     AND kpi.KPI_Name <> 'Sales volume (MT)2'
                --    AND kpi.KPI_Name <> 'ICO BUD'
                THEN ffs.conso_adjusted_amount * dacc.account_reporting_sign
               WHEN (dco.consolidation_category = 'ACT'
               
                    or (dco.consolidation_category = 'BGAAP' and TRY_CAST(dat.year AS INT) < 2024 ))
                     AND dco.consolidation_version = 0
                     AND kpi.KPI_Name = 'Sales volume (MT)1'
                THEN ffs.volume_amount  
            WHEN (dco.consolidation_category = 'ACT'
               
                    or (dco.consolidation_category = 'BGAAP' and TRY_CAST(dat.year AS INT) < 2024 ))
                     AND dco.consolidation_version = 0
                     AND kpi.KPI_Name = 'Sales volume (MT)2'
                   
                THEN ffs.volume_amount * -1
                ELSE 0
            END) AS ytd_conso_adjusted_amount_act,
       
       

        -- Forecast: sum bundle and adjusted amounts for forecast category
        SUM(CASE
                WHEN dco.consolidation_category = 'FCT'
                     AND kpi.KPI_Name <> 'Sales volume (MT)1'
                     AND kpi.KPI_Name <> 'Sales volume (MT)2'
                    AND dco.consolidation_version <> 9
                  --    AND kpi.KPI_Name <> 'ICO BUD'
                THEN ffs.bundle_amount * dacc.account_reporting_sign
               WHEN dco.consolidation_category = 'FCT'
                    AND dco.consolidation_version <> 9
                    AND kpi.KPI_Name = 'Sales volume (MT)1'                  
                THEN ffs.volume_amount  
                WHEN dco.consolidation_category = 'FCT'
                    AND dco.consolidation_version <> 9
                    AND kpi.KPI_Name = 'Sales volume (MT)2'                  
                THEN ffs.volume_amount  * -1
                ELSE 0
            END) AS ytd_bundle_amount_fct,
        SUM(CASE
                WHEN dco.consolidation_category = 'FCT'
                     AND kpi.KPI_Name <> 'Sales volume (MT)1'
                     AND kpi.KPI_Name <> 'Sales volume (MT)2'
                     AND dco.consolidation_version <> 9
                    --  AND kpi.KPI_Name <> 'ICO BUD'
                THEN ffs.conso_adjusted_amount * dacc.account_reporting_sign
                WHEN dco.consolidation_category = 'FCT'
                    AND dco.consolidation_version <> 9
                    AND kpi.KPI_Name = 'Sales volume (MT)1'
                THEN ffs.volume_amount  
                  WHEN dco.consolidation_category = 'FCT'
                    AND dco.consolidation_version <> 9
                    AND kpi.KPI_Name = 'Sales volume (MT)2'
                THEN ffs.volume_amount * -1
                ELSE 0
            END) AS ytd_conso_adjusted_amount_fct,
       

         -- Budget: sum bundle and adjusted amounts for budget category
        SUM(CASE
                WHEN dco.consolidation_category = 'BUD'
                       AND kpi.KPI_Name <> 'Sales volume (MT)1'
                     AND kpi.KPI_Name <> 'Sales volume (MT)2'
                     --AND kpi.KPI_Name <> 'ICO BUD'
                    AND dco.consolidation_version = 0
                THEN ffs.bundle_amount * dacc.account_reporting_sign
                WHEN dco.consolidation_category = 'BUD'
                    AND kpi.KPI_Name = 'Sales volume (MT)1'
                    AND dco.consolidation_version = 0
                THEN ffs.volume_amount  
                   WHEN dco.consolidation_category = 'BUD'
                    AND kpi.KPI_Name = 'Sales volume (MT)2'
                    AND dco.consolidation_version = 0
                THEN ffs.volume_amount * -1
                 --WHEN dco.consolidation_category = 'BUD'
                   -- AND kpi.KPI_Name = 'ICO BUD'
                    --AND dco.consolidation_version = 0
                --THEN ffs.intercompany_amount * -1
                ELSE 0
            END) AS ytd_bundle_amount_bud,
        SUM(CASE
                WHEN dco.consolidation_category = 'BUD'
                     AND kpi.KPI_Name <> 'Sales volume (MT)1'
                     AND kpi.KPI_Name <> 'Sales volume (MT)2'
                    AND dco.consolidation_version = 0
                  --    AND kpi.KPI_Name <> 'ICO BUD'
                THEN ffs.conso_adjusted_amount * dacc.account_reporting_sign
                WHEN dco.consolidation_category = 'BUD'
                   
                    AND kpi.KPI_Name = 'Sales volume (MT)1'
                    AND dco.consolidation_version = 0
                THEN ffs.volume_amount
                 WHEN dco.consolidation_category = 'BUD'
                   
                    AND kpi.KPI_Name = 'Sales volume (MT)2'
                    AND dco.consolidation_version = 0
                THEN ffs.volume_amount  * -1

                --WHEN dco.consolidation_category = 'BUD'
                  --  AND kpi.KPI_Name = 'ICO BUD'
                   -- AND dco.consolidation_version = 0
                --THEN ffs.intercompany_amount * -1
                ELSE 0
            END) AS ytd_conso_adjusted_amount_bud
    FROM
        {{ ref('fact_financial_statements') }} ffs
    INNER JOIN
        {{ ref('dim_consolidation_period') }} dco ON ffs.tkey_consolidation_period = dco.tkey_consolidation_period
    INNER JOIN
        {{ ref('dim_account') }} dacc ON ffs.tkey_account = dacc.tkey_account
    INNER JOIN
        {{ ref('dim_date') }} dat ON ffs.tkey_date = dat.tkey_date
    INNER JOIN
        {{ ref('dim_company') }} dcom ON ffs.tkey_company = dcom.tkey_company
    INNER JOIN KPI_Mapping kpi ON
    (
        (kpi.AHL1 IS NOT NULL AND kpi.AHL2 IS NOT NULL AND
         dacc.account_hierarchy_level_1 = kpi.AHL1 AND dacc.account_hierarchy_level_2 = kpi.AHL2)
        OR
        (kpi.AHL1 IS NOT NULL AND kpi.AHL2 IS NULL AND
         dacc.account_hierarchy_level_1 = kpi.AHL1)
        OR
        (kpi.AHL1 IS NULL AND kpi.AHL2 IS NOT NULL AND
         dacc.account_hierarchy_level_2 = kpi.AHL2)
        OR
        (kpi.BKEY_Account IS NOT NULL AND dacc.bkey_account = kpi.BKEY_Account)
        OR
        (kpi.AHL3 IS NOT NULL AND dacc.account_hierarchy_level_3 = kpi.AHL3)
        OR
        (kpi.Account_Description IS NOT NULL AND dacc.account_description = kpi.Account_Description)
    )
    WHERE dacc.account_reporting_view = 'Management View 2020'
    AND (dco.consolidation_category IN ('ACT','BUD','FCT')
    OR (dco.consolidation_category = 'BGAAP' AND TRY_CAST(dat.year AS INT) < 2024 ))
    AND dco.consolidation_version <> 9     
    AND TRY_CAST(dat.year AS INT) >= 2020
    AND consolidation_L4L_scope is not null
    GROUP BY
        kpi.KPI_Name,
        dco.consolidation_category,
        dco.consolidation_version,
        dco.consolidation_scope,
        CONVERT(DATE, CONVERT(VARCHAR(8), ffs.tkey_date)),
        ffs.tkey_company,
        dcom.company_code,
        ffs.tkey_consolidation_period,
        dco.consolidation_L4L_scope,
        dco.consolidation_code,
        dat.year  
),

Monthly_Turnover_KPI AS (
    SELECT
        KPI_Name,
        tkey_date,
        tkey_company,
        tkey_consolidation_period,
        consolidation_category,
        consolidation_version,
        consolidation_scope,
        consolidation_L4L_scope,
        company_code,

        ytd_bundle_amount_act
          - COALESCE(
              LAG(ytd_bundle_amount_act) OVER (
                PARTITION BY company_code, consolidation_category, consolidation_version,
                             consolidation_scope, consolidation_L4L_scope, YEAR(tkey_date)
                ORDER BY tkey_date
              ),
              0
            ) AS monthly_bundle_amount_act,

        ytd_conso_adjusted_amount_act
          - COALESCE(
              LAG(ytd_conso_adjusted_amount_act) OVER (
                PARTITION BY company_code, consolidation_category, consolidation_version,
                             consolidation_scope, consolidation_L4L_scope, YEAR(tkey_date)
                ORDER BY tkey_date
              ),
              0
            ) AS monthly_conso_adjusted_amount_act,

        ytd_bundle_amount_fct
          - COALESCE(
              LAG(ytd_bundle_amount_fct) OVER (
                PARTITION BY company_code, consolidation_category, consolidation_version,
                             consolidation_scope, consolidation_L4L_scope, YEAR(tkey_date)
                ORDER BY tkey_date
              ),
              0
            ) AS monthly_bundle_amount_fct,

        ytd_conso_adjusted_amount_fct
          - COALESCE(
              LAG(ytd_conso_adjusted_amount_fct) OVER (
                PARTITION BY company_code, consolidation_category, consolidation_version,
                             consolidation_scope, consolidation_L4L_scope, YEAR(tkey_date)
                ORDER BY tkey_date
              ),
              0
            ) AS monthly_conso_adjusted_amount_fct,

        ytd_bundle_amount_bud
          - COALESCE(
              LAG(ytd_bundle_amount_bud) OVER (
                PARTITION BY company_code, consolidation_category, consolidation_version,
                             consolidation_scope, consolidation_L4L_scope, YEAR(tkey_date)
                ORDER BY tkey_date
              ),
              0
            ) AS monthly_bundle_amount_bud,

        ytd_conso_adjusted_amount_bud
          - COALESCE(
              LAG(ytd_conso_adjusted_amount_bud) OVER (
                PARTITION BY company_code, consolidation_category, consolidation_version,
                             consolidation_scope, consolidation_L4L_scope, YEAR(tkey_date)
                ORDER BY tkey_date
              ),
              0
            ) AS monthly_conso_adjusted_amount_bud

    FROM Base_KPI
    WHERE KPI_Name = 'Turnover'
),

--Step 2c: Calculate Monthly values for Cost of Goods Sold
Monthly_COGS1_KPI AS (
    SELECT
        KPI_Name,
        tkey_date,
        tkey_company,
        tkey_consolidation_period,
        consolidation_category,
        consolidation_version,
        consolidation_scope,
        consolidation_L4L_scope,
        company_code,

        -- derive monthly values (current YTD - previous YTD)
        ytd_bundle_amount_act
            - COALESCE(
                LAG(ytd_bundle_amount_act) OVER (
                    PARTITION BY company_code, consolidation_category, consolidation_version,
                                 consolidation_scope, consolidation_L4L_scope, YEAR(tkey_date)
                    ORDER BY tkey_date
                ),
                0
              ) AS cogs1_monthly_bundle_amount_act,

        ytd_conso_adjusted_amount_act
            - COALESCE(
                LAG(ytd_conso_adjusted_amount_act) OVER (
                    PARTITION BY company_code, consolidation_category, consolidation_version,
                                 consolidation_scope, consolidation_L4L_scope, YEAR(tkey_date)
                    ORDER BY tkey_date
                ),
                0
              ) AS cogs1_monthly_conso_adjusted_amount_act,

        ytd_bundle_amount_fct
            - COALESCE(
                LAG(ytd_bundle_amount_fct) OVER (
                    PARTITION BY company_code, consolidation_category, consolidation_version,
                                 consolidation_scope, consolidation_L4L_scope, YEAR(tkey_date)
                    ORDER BY tkey_date
                ),
                0
              ) AS cogs1_monthly_bundle_amount_fct,

        ytd_conso_adjusted_amount_fct
            - COALESCE(
                LAG(ytd_conso_adjusted_amount_fct) OVER (
                    PARTITION BY company_code, consolidation_category, consolidation_version,
                                 consolidation_scope, consolidation_L4L_scope, YEAR(tkey_date)
                    ORDER BY tkey_date
                ),
                0
              ) AS cogs1_monthly_conso_adjusted_amount_fct,

        ytd_bundle_amount_bud
            - COALESCE(
                LAG(ytd_bundle_amount_bud) OVER (
                    PARTITION BY company_code, consolidation_category, consolidation_version,
                                 consolidation_scope, consolidation_L4L_scope, YEAR(tkey_date)
                    ORDER BY tkey_date
                ),
                0
              ) AS cogs1_monthly_bundle_amount_bud,

        ytd_conso_adjusted_amount_bud
            - COALESCE(
                LAG(ytd_conso_adjusted_amount_bud) OVER (
                    PARTITION BY company_code, consolidation_category, consolidation_version,
                                 consolidation_scope, consolidation_L4L_scope, YEAR(tkey_date)
                    ORDER BY tkey_date
                ),
                0
              ) AS cogs1_monthly_conso_adjusted_amount_bud
    FROM Base_KPI
    WHERE KPI_Name = 'COGS1'
),

--Step 2d: Calculate Monthly values for Adjusted EBIT
Monthly_EBIT_KPI AS (
    SELECT
        KPI_Name,
        tkey_date,
        tkey_company,
        tkey_consolidation_period,
        consolidation_category,
        consolidation_version,
        consolidation_scope,
        consolidation_L4L_scope,
        company_code,

        -- derive monthly values (current YTD - previous YTD)
        ytd_bundle_amount_act
            - COALESCE(
                LAG(ytd_bundle_amount_act) OVER (
                    PARTITION BY KPI_Name, company_code, consolidation_category,
                                 consolidation_version, consolidation_scope,
                                 consolidation_L4L_scope, YEAR(tkey_date)
                    ORDER BY tkey_date
                ),
                0
              ) AS ebit_monthly_bundle_amount_act,

        ytd_conso_adjusted_amount_act
            - COALESCE(
                LAG(ytd_conso_adjusted_amount_act) OVER (
                    PARTITION BY KPI_Name, company_code, consolidation_category,
                                 consolidation_version, consolidation_scope,
                                 consolidation_L4L_scope, YEAR(tkey_date)
                    ORDER BY tkey_date
                ),
                0
              ) AS ebit_monthly_conso_adjusted_amount_act,

        ytd_bundle_amount_fct
            - COALESCE(
                LAG(ytd_bundle_amount_fct) OVER (
                    PARTITION BY KPI_Name, company_code, consolidation_category,
                                 consolidation_version, consolidation_scope,
                                 consolidation_L4L_scope, YEAR(tkey_date)
                    ORDER BY tkey_date
                ),
                0
              ) AS ebit_monthly_bundle_amount_fct,

        ytd_conso_adjusted_amount_fct
            - COALESCE(
                LAG(ytd_conso_adjusted_amount_fct) OVER (
                    PARTITION BY KPI_Name, company_code, consolidation_category,
                                 consolidation_version, consolidation_scope,
                                 consolidation_L4L_scope, YEAR(tkey_date)
                    ORDER BY tkey_date
                ),
                0
              ) AS ebit_monthly_conso_adjusted_amount_fct,

        ytd_bundle_amount_bud
            - COALESCE(
                LAG(ytd_bundle_amount_bud) OVER (
                    PARTITION BY KPI_Name, company_code, consolidation_category,
                                 consolidation_version, consolidation_scope,
                                 consolidation_L4L_scope, YEAR(tkey_date)
                    ORDER BY tkey_date
                ),
                0
              ) AS ebit_monthly_bundle_amount_bud,

        ytd_conso_adjusted_amount_bud
            - COALESCE(
                LAG(ytd_conso_adjusted_amount_bud) OVER (
                    PARTITION BY KPI_Name, company_code, consolidation_category,
                                 consolidation_version, consolidation_scope,
                                 consolidation_L4L_scope, YEAR(tkey_date)
                    ORDER BY tkey_date
                ),
                0
              ) AS ebit_monthly_conso_adjusted_amount_bud
    FROM Base_KPI
    WHERE KPI_Name IN (
        'Turnover',
        'COGS1',
        'COGS2',
        'Transactional financing cost',
        'Realized FX on Natural Hedge',
        'Other Income',
        'Overheads',
        'Depreciations and Amortizations'
    )
),

--Step 2e: Calculate Monthly values for Capital Invested
Monthly_CI_KPI AS (
    SELECT
        KPI_Name,
        tkey_date,
        tkey_company,
        tkey_consolidation_period,
        consolidation_category,
        consolidation_version,
        consolidation_scope,
        consolidation_L4L_scope,  
        company_code,
        ytd_bundle_amount_act AS ci_monthly_bundle_amount_act,
        ytd_conso_adjusted_amount_act AS ci_monthly_conso_adjusted_amount_act,
        ytd_bundle_amount_fct AS ci_monthly_bundle_amount_fct,
        ytd_conso_adjusted_amount_fct AS ci_monthly_conso_adjusted_amount_fct,
        ytd_bundle_amount_bud  AS ci_monthly_bundle_amount_bud,
        ytd_conso_adjusted_amount_bud AS ci_monthly_conso_adjusted_amount_bud
    FROM Base_KPI
    WHERE KPI_Name = 'Capital Invested'
),

-- Step 3: Calculate SUM L3M for Turnover
L3M_KPI AS (
    SELECT
        'L3M' AS KPI_Name,
        curr.tkey_date,
        curr.tkey_company,
        curr.tkey_consolidation_period,

        -- sum across last 3 months of derived monthly values
        SUM(prev.monthly_bundle_amount_act) AS l3m_bundle_amount_act,
        SUM(prev.monthly_conso_adjusted_amount_act) AS l3m_conso_adjusted_amount_act,
        SUM(prev.monthly_bundle_amount_fct) AS l3m_bundle_amount_fct,
        SUM(prev.monthly_conso_adjusted_amount_fct) AS l3m_conso_adjusted_amount_fct,
        SUM(prev.monthly_bundle_amount_bud) AS l3m_bundle_amount_bud,
        SUM(prev.monthly_conso_adjusted_amount_bud) AS l3m_conso_adjusted_amount_bud

    FROM Monthly_Turnover_KPI  curr
    JOIN Monthly_Turnover_KPI  prev
        ON curr.company_code = prev.company_code
        AND curr.consolidation_category = prev.consolidation_category
        AND curr.consolidation_version = prev.consolidation_version
        AND curr.consolidation_scope = prev.consolidation_scope
        AND curr.consolidation_L4L_scope = prev.consolidation_L4L_scope
        AND prev.tkey_date BETWEEN
            CONVERT(INT, FORMAT(DATEADD(MONTH, -2, CONVERT(DATE, curr.tkey_date)), 'yyyyMMdd'))
            AND curr.tkey_date
    GROUP BY
        curr.tkey_date,
        curr.tkey_company,
        curr.tkey_consolidation_period
),

-- Step 3: Calculate SUM L12M for Adjusted EBIT
L12MEBIT_KPI AS (
    SELECT
        'L12MEBIT' AS KPI_Name,
        curr.tkey_date,
        curr.tkey_company,
        curr.tkey_consolidation_period,

        -- sum across last 12 months of derived monthly values
        SUM(prev.ebit_monthly_bundle_amount_act) AS L12MEBIT_bundle_amount_act,
        SUM(prev.ebit_monthly_conso_adjusted_amount_act) AS L12MEBIT_conso_adjusted_amount_act,
        SUM(prev.ebit_monthly_bundle_amount_fct) AS  L12MEBIT_bundle_amount_fct,
        SUM(prev.ebit_monthly_conso_adjusted_amount_fct) AS  L12MEBIT_conso_adjusted_amount_fct,
        SUM(prev.ebit_monthly_bundle_amount_bud) AS  L12MEBIT_bundle_amount_bud,
        SUM(prev.ebit_monthly_conso_adjusted_amount_bud) AS  L12MEBIT_conso_adjusted_amount_bud

    FROM Monthly_EBIT_KPI curr
    JOIN  Monthly_EBIT_KPI  prev
        ON curr.company_code = prev.company_code
        AND curr.consolidation_category = prev.consolidation_category
        AND curr.consolidation_version = prev.consolidation_version
        AND curr.consolidation_scope = prev.consolidation_scope
        AND curr.consolidation_L4L_scope = prev.consolidation_L4L_scope
        AND curr. KPI_Name = prev. KPI_Name      
        AND prev.tkey_date BETWEEN
            CONVERT(INT, FORMAT(DATEADD(MONTH, -11, CONVERT(DATE, curr.tkey_date)), 'yyyyMMdd'))
            AND curr.tkey_date
    GROUP BY
        curr.tkey_date,
        curr.tkey_company,
        curr.tkey_consolidation_period
),

L12M_CI AS (
    SELECT
        'L12MCI' AS KPI_Name,
        curr.tkey_date,
        curr.tkey_company,
        curr.tkey_consolidation_period,

        -- sum across last 3 months of derived monthly values
        SUM(prev.ci_monthly_bundle_amount_act) AS l12mci_bundle_amount_act,
        SUM(prev.ci_monthly_conso_adjusted_amount_act) AS l12mci_conso_adjusted_amount_act,
        SUM(prev.ci_monthly_bundle_amount_fct) AS l12mci_bundle_amount_fct,
        SUM(prev.ci_monthly_conso_adjusted_amount_fct) AS l12mci_conso_adjusted_amount_fct,
        SUM(prev.ci_monthly_bundle_amount_bud) AS l12mci_bundle_amount_bud,
        SUM(prev.ci_monthly_conso_adjusted_amount_bud) AS l12mci_conso_adjusted_amount_bud

    FROM Monthly_CI_KPI  curr
    JOIN Monthly_CI_KPI  prev
        ON curr.company_code = prev.company_code
        AND curr.consolidation_category = prev.consolidation_category
        AND curr.consolidation_version = prev.consolidation_version
        AND curr.consolidation_scope = prev.consolidation_scope
        AND curr.consolidation_L4L_scope = prev.consolidation_L4L_scope
        AND prev.tkey_date BETWEEN
            CONVERT(INT, FORMAT(DATEADD(MONTH, -11, CONVERT(DATE, curr.tkey_date)), 'yyyyMMdd'))
            AND curr.tkey_date
    GROUP BY
        curr.tkey_date,
        curr.tkey_company,
        curr.tkey_consolidation_period
),

-- Step 3c: Calculate SUML3M for COGS1
L3M_COGS1_KPI AS (
    SELECT
        'L3MCOGS1' AS KPI_Name,
        curr.tkey_date,
        curr.tkey_company,
        curr.tkey_consolidation_period,
       
        -- sum across last 3 months of derived monthly values
        SUM(prev.cogs1_monthly_bundle_amount_act) AS l3mcogs1_bundle_amount_act,
        SUM(prev.cogs1_monthly_conso_adjusted_amount_act) AS l3mcogs1_conso_adjusted_amount_act,
        SUM(prev.cogs1_monthly_bundle_amount_fct) AS l3mcogs1_bundle_amount_fct,
        SUM(prev.cogs1_monthly_conso_adjusted_amount_fct) AS l3mcogs1_conso_adjusted_amount_fct,
        SUM(prev.cogs1_monthly_bundle_amount_bud) AS l3mcogs1_bundle_amount_bud,
        SUM(prev.cogs1_monthly_conso_adjusted_amount_bud) AS l3mcogs1_conso_adjusted_amount_bud

    FROM Monthly_COGS1_KPI  curr
    JOIN Monthly_COGS1_KPI  prev
        ON curr.company_code = prev.company_code
        AND curr.consolidation_category = prev.consolidation_category
        AND curr.consolidation_version = prev.consolidation_version
        AND curr.consolidation_scope = prev.consolidation_scope
        AND curr.consolidation_L4L_scope = prev.consolidation_L4L_scope
        AND prev.tkey_date BETWEEN
            CONVERT(INT, FORMAT(DATEADD(MONTH, -2, CONVERT(DATE, curr.tkey_date)), 'yyyyMMdd'))
            AND curr.tkey_date
    GROUP BY
        curr.tkey_date,
        curr.tkey_company,
        curr.tkey_consolidation_period
),

-- Step 5: Calculate aggregated KPIs based on base KPIs (build hierarchies of KPIs)
Final_KPIs AS (

    -- Include all base KPIs first
    SELECT   
        KPI_Name,
        tkey_date,
        tkey_company,
        tkey_consolidation_period,
        ytd_bundle_amount_act,
        ytd_conso_adjusted_amount_act,
        ytd_bundle_amount_fct,
        ytd_conso_adjusted_amount_fct,
        ytd_bundle_amount_bud,
        ytd_conso_adjusted_amount_bud
    FROM Base_KPI

    UNION ALL
    
    -- Calculate Sales Volume making sure intercompany volumes are excluded
    SELECT
        'Sales volume (MT)' AS KPI_Name,
        tkey_date,
        tkey_company,
        tkey_consolidation_period,

        SUM(CASE WHEN KPI_Name IN ('Sales volume (MT)1','Sales volume (MT)2') THEN ytd_bundle_amount_act ELSE 0 END) AS ytd_bundle_amount_act,
        SUM(CASE WHEN KPI_Name IN ('Sales volume (MT)1','Sales volume (MT)2') THEN ytd_conso_adjusted_amount_act ELSE 0 END) AS ytd_conso_adjusted_amount_act,
    
        SUM(CASE WHEN KPI_Name IN ('Sales volume (MT)1','Sales volume (MT)2') THEN ytd_bundle_amount_fct ELSE 0 END) AS ytd_bundle_amount_fct,
        SUM(CASE WHEN KPI_Name IN ('Sales volume (MT)1','Sales volume (MT)2')THEN ytd_conso_adjusted_amount_fct ELSE 0 END) AS ytd_conso_adjusted_amount_fct,
    
        SUM(CASE WHEN KPI_Name IN ('Sales volume (MT)1','Sales volume (MT)2') THEN ytd_bundle_amount_bud ELSE 0 END) AS ytd_bundle_amount_bud,
        SUM(CASE WHEN KPI_Name IN ('Sales volume (MT)1','Sales volume (MT)2') THEN ytd_conso_adjusted_amount_bud ELSE 0 END) AS ytd_conso_adjusted_amount_bud
    
    FROM Base_KPI
    WHERE KPI_Name IN ('Sales volume (MT)1','Sales volume (MT)2')
    GROUP BY tkey_date, tkey_company, tkey_consolidation_period

    UNION ALL

    -- Calculate 'Gross Profit' KPI by aggregating Turnover and COGS KPIs
    SELECT
        'Gross Profit' AS KPI_Name,
        tkey_date,
        tkey_company,
        tkey_consolidation_period,

        SUM(CASE WHEN KPI_Name IN ('Turnover', 'COGS1', 'COGS2') THEN ytd_bundle_amount_act ELSE 0 END) AS ytd_bundle_amount_act,
        SUM(CASE WHEN KPI_Name IN ('Turnover', 'COGS1', 'COGS2') THEN ytd_conso_adjusted_amount_act ELSE 0 END) AS ytd_conso_adjusted_amount_act,
    
        SUM(CASE WHEN KPI_Name IN ('Turnover', 'COGS1', 'COGS2') THEN ytd_bundle_amount_fct ELSE 0 END) AS ytd_bundle_amount_fct,
        SUM(CASE WHEN KPI_Name IN ('Turnover', 'COGS1', 'COGS2') THEN ytd_conso_adjusted_amount_fct ELSE 0 END) AS ytd_conso_adjusted_amount_fct,
    
        SUM(CASE WHEN KPI_Name IN ('Turnover', 'COGS1', 'COGS2') THEN ytd_bundle_amount_bud ELSE 0 END) AS ytd_bundle_amount_bud,
        SUM(CASE WHEN KPI_Name IN ('Turnover', 'COGS1', 'COGS2') THEN ytd_conso_adjusted_amount_bud ELSE 0 END) AS ytd_conso_adjusted_amount_bud
    
    FROM Base_KPI
    WHERE KPI_Name IN ('Turnover', 'COGS1', 'COGS2')
    GROUP BY tkey_date, tkey_company, tkey_consolidation_period

    UNION ALL
    
    SELECT
        'Adjusted GP' AS KPI_Name,
        tkey_date,
        tkey_company,
        tkey_consolidation_period,

        SUM(CASE WHEN KPI_Name IN ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge') THEN ytd_bundle_amount_act ELSE 0 END) AS ytd_bundle_amount_act,
        SUM(CASE WHEN KPI_Name IN ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge') THEN ytd_conso_adjusted_amount_act ELSE 0 END) AS ytd_conso_adjusted_amount_act,
    
        SUM(CASE WHEN KPI_Name IN ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge') THEN ytd_bundle_amount_fct ELSE 0 END) AS ytd_bundle_amount_fct,
        SUM(CASE WHEN KPI_Name IN ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge') THEN ytd_conso_adjusted_amount_fct ELSE 0 END) AS ytd_conso_adjusted_amount_fct,
    
        SUM(CASE WHEN KPI_Name IN ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge') THEN ytd_bundle_amount_bud ELSE 0 END) AS ytd_bundle_amount_bud,
        SUM(CASE WHEN KPI_Name IN ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge')THEN ytd_conso_adjusted_amount_bud ELSE 0 END) AS ytd_conso_adjusted_amount_bud
    
    FROM Base_KPI
    WHERE KPI_Name IN ('Turnover', 'COGS1', 'COGS2','Gross Profit', 'Transactional financing cost', 'Realized FX on Natural Hedge')
    GROUP BY tkey_date, tkey_company, tkey_consolidation_period

    UNION ALL
    
    -- Calculate 'Adjusted EBITDA' KPI using Overheads, Other Income, Depreciations, and Gross Profit
    SELECT
        'Local Overheads' AS KPI_Name,
        tkey_date,
        tkey_company,
        tkey_consolidation_period,
    

        SUM(CASE WHEN KPI_Name IN ('Overheads') THEN ytd_bundle_amount_act ELSE 0 END)
        -
        SUM(CASE WHEN KPI_Name IN ('Recharges') THEN ytd_bundle_amount_act
        ELSE 0 END) AS ytd_bundle_amount_act,

        SUM(CASE WHEN KPI_Name IN ('Overheads') THEN ytd_conso_adjusted_amount_act ELSE 0 END)
        -
        SUM(CASE WHEN KPI_Name IN ('Recharges')  THEN ytd_conso_adjusted_amount_act
        ELSE 0 END) AS ytd_conso_adjusted_amount_act,
    
        SUM(CASE WHEN KPI_Name IN ('Overheads') THEN ytd_bundle_amount_fct ELSE 0 END)
        -
        SUM(CASE WHEN KPI_Name IN ('Recharges')  THEN  ytd_bundle_amount_fct
        ELSE 0 END) AS ytd_bundle_amount_fct,

        SUM(CASE WHEN KPI_Name IN ('Overheads') THEN ytd_conso_adjusted_amount_fct ELSE 0 END)  
        -
        SUM(CASE WHEN KPI_Name IN ('Recharges')  THEN  ytd_conso_adjusted_amount_fct
        ELSE 0 END) AS ytd_conso_adjusted_amount_fct,

        SUM(CASE WHEN KPI_Name IN ('Overheads') THEN ytd_bundle_amount_bud ELSE 0 END)
        -
        SUM(CASE WHEN KPI_Name IN ('Recharges')  THEN  ytd_bundle_amount_bud
        ELSE 0 END) AS ytd_bundle_amount_bud,

        SUM(CASE WHEN KPI_Name IN ('Overheads')THEN ytd_conso_adjusted_amount_bud ELSE 0 END)
        -
        SUM(CASE WHEN KPI_Name IN ('Recharges')  THEN  ytd_conso_adjusted_amount_bud
        ELSE 0 END) AS ytd_conso_adjusted_amount_bud
    
    FROM Base_KPI
    WHERE KPI_Name IN ('Overheads','Recharges')
    GROUP BY tkey_date, tkey_company, tkey_consolidation_period

    UNION ALL


    SELECT
        'Adjusted EBITDA' AS KPI_Name,
        tkey_date,
        tkey_company,
        tkey_consolidation_period,

        SUM(CASE WHEN KPI_Name IN ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge', 'Other Income', 'Overheads') THEN ytd_bundle_amount_act ELSE 0 END) AS ytd_bundle_amount_act,
        SUM(CASE WHEN KPI_Name IN ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge', 'Other Income', 'Overheads') THEN ytd_conso_adjusted_amount_act ELSE 0 END) AS ytd_conso_adjusted_amount_act,
    
        SUM(CASE WHEN KPI_Name IN  ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge', 'Other Income', 'Overheads') THEN ytd_bundle_amount_fct ELSE 0 END) AS ytd_bundle_amount_fct,
        SUM(CASE WHEN KPI_Name IN  ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge', 'Other Income', 'Overheads')THEN ytd_conso_adjusted_amount_fct ELSE 0 END) AS ytd_conso_adjusted_amount_fct,
    
        SUM(CASE WHEN KPI_Name IN  ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge', 'Other Income', 'Overheads') THEN ytd_bundle_amount_bud ELSE 0 END) AS ytd_bundle_amount_bud,
        SUM(CASE WHEN KPI_Name IN  ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge', 'Other Income', 'Overheads')THEN ytd_conso_adjusted_amount_bud ELSE 0 END) AS ytd_conso_adjusted_amount_bud
    
    FROM Base_KPI
    WHERE KPI_Name IN  ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge', 'Other Income', 'Overheads')
    GROUP BY tkey_date, tkey_company, tkey_consolidation_period

    UNION ALL

    SELECT
        'Adjusted EBIT' AS KPI_Name,
        tkey_date,
        tkey_company,
        tkey_consolidation_period,

        SUM(CASE WHEN KPI_Name IN ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge', 'Other Income', 'Overheads', 'Depreciations and Amortizations') THEN ytd_bundle_amount_act ELSE 0 END) AS ytd_bundle_amount_act,
        SUM(CASE WHEN KPI_Name IN ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge', 'Other Income', 'Overheads', 'Depreciations and Amortizations') THEN ytd_conso_adjusted_amount_act ELSE 0 END) AS ytd_conso_adjusted_amount_act ,
    
        SUM(CASE WHEN KPI_Name IN ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge', 'Other Income', 'Overheads', 'Depreciations and Amortizations') THEN ytd_bundle_amount_fct ELSE 0 END) AS ytd_bundle_amount_fct ,
        SUM(CASE WHEN KPI_Name IN ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge', 'Other Income', 'Overheads', 'Depreciations and Amortizations') THEN ytd_conso_adjusted_amount_fct ELSE 0 END) AS ytd_conso_adjusted_amount_fct ,
    
        SUM(CASE WHEN KPI_Name IN ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge', 'Other Income', 'Overheads', 'Depreciations and Amortizations') THEN ytd_bundle_amount_bud ELSE 0 END) AS ytd_bundle_amount_bud,
        SUM(CASE WHEN KPI_Name IN ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge', 'Other Income', 'Overheads', 'Depreciations and Amortizations') THEN ytd_conso_adjusted_amount_bud ELSE 0 END) AS ytd_conso_adjusted_amount_bud
    
    FROM Base_KPI
    WHERE KPI_Name IN ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge', 'Other Income', 'Overheads', 'Depreciations and Amortizations')
    GROUP BY tkey_date, tkey_company, tkey_consolidation_period

    -- Calculate 'Realized FX on exposure' KPI by subtracting unrealized FX from Forex
    UNION ALL
    
    SELECT
        'Realized FX on exposure' AS KPI_Name,
        tkey_date,
        tkey_company,
        tkey_consolidation_period,
    
        SUM(CASE WHEN KPI_Name IN ('Forex') THEN ytd_bundle_amount_act ELSE 0 END)
        - SUM(CASE WHEN KPI_Name IN ('Unrealized FX') THEN ytd_bundle_amount_act ELSE 0 END)
        as ytd_bundle_amount_act,
    

        SUM(CASE WHEN KPI_Name IN ('Forex') THEN ytd_conso_adjusted_amount_act ELSE 0 END)
        -  SUM(CASE WHEN KPI_Name IN ('Unrealized FX') THEN ytd_conso_adjusted_amount_act ELSE 0 END)
        AS ytd_conso_adjusted_amount_act,
    

        SUM(CASE WHEN KPI_Name IN ('Forex') THEN ytd_bundle_amount_fct ELSE 0 END)
        -    SUM(CASE WHEN KPI_Name IN ('Unrealized FX') THEN ytd_bundle_amount_fct ELSE 0 END)
        AS ytd_bundle_amount_fct,


        SUM(CASE WHEN KPI_Name IN ('Forex')  THEN ytd_conso_adjusted_amount_fct ELSE 0 END)  
        - SUM(CASE WHEN KPI_Name IN ('Unrealized FX')  THEN ytd_conso_adjusted_amount_fct ELSE 0 END)  
        AS ytd_conso_adjusted_amount_fct,

    
        SUM(CASE WHEN KPI_Name IN ('Forex')  THEN ytd_bundle_amount_bud ELSE 0 END)
        -  SUM(CASE WHEN KPI_Name IN ('Unrealized FX')  THEN ytd_bundle_amount_bud ELSE 0 END)
        AS ytd_bundle_amount_bud,


        SUM(CASE WHEN KPI_Name IN ('Forex')   THEN ytd_conso_adjusted_amount_bud ELSE 0 END)
        - SUM(CASE WHEN KPI_Name IN ('Unrealized FX')   THEN ytd_conso_adjusted_amount_bud ELSE 0 END)
        AS ytd_conso_adjusted_amount_bud
    
    FROM Base_KPI
    WHERE KPI_Name IN ('Forex','Unrealized FX')
    GROUP BY tkey_date, tkey_company, tkey_consolidation_period

    -- Calculate 'Earnings Before Taxes' KPI by aggregating Adjusted EBIT and financing related KPIs

    UNION ALL

    SELECT
        'Earnings Before Taxes' AS KPI_Name,
        tkey_date,
        tkey_company,
        tkey_consolidation_period,

        -- Actuals
        SUM(CASE WHEN KPI_Name IN ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge', 'Other Income', 'Overheads', 'Depreciations and Amortizations',  'Unrealized FX', 'Forex','Financing result', 'Banking costs','Non-Recurring Other') THEN ytd_bundle_amount_act ELSE 0 END)
        -   SUM(CASE WHEN KPI_Name IN ('Unrealized FX') THEN ytd_bundle_amount_act ELSE 0 END)
        AS ytd_bundle_amount_act,

        SUM(CASE WHEN KPI_Name IN ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge', 'Other Income', 'Overheads', 'Depreciations and Amortizations',  'Unrealized FX','Forex', 'Financing result', 'Banking costs','Non-Recurring Other') THEN ytd_conso_adjusted_amount_act ELSE 0 END)
        - SUM(CASE WHEN KPI_Name IN ('Unrealized FX') THEN  ytd_conso_adjusted_amount_act ELSE 0 END)
        AS ytd_conso_adjusted_amount_act,
    

        -- Forecast
        SUM(CASE WHEN KPI_Name IN ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge', 'Other Income', 'Overheads', 'Depreciations and Amortizations',  'Unrealized FX', 'Forex','Financing result', 'Banking costs','Non-Recurring Other') THEN ytd_bundle_amount_fct ELSE 0 END)
        - SUM(CASE WHEN KPI_Name IN ('Unrealized FX') THEN  ytd_bundle_amount_fct ELSE 0 END)
        AS ytd_bundle_amount_fct,

        SUM(CASE WHEN KPI_Name IN ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge', 'Other Income', 'Overheads', 'Depreciations and Amortizations', 'Unrealized FX', 'Forex','Financing result', 'Banking costs','Non-Recurring Other') THEN ytd_conso_adjusted_amount_fct ELSE 0 END)
        - SUM(CASE WHEN KPI_Name IN ('Unrealized FX') THEN  ytd_conso_adjusted_amount_fct ELSE 0 END)
        AS ytd_conso_adjusted_amount_fct,
    

        -- Budget
        SUM(CASE WHEN KPI_Name IN ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge', 'Other Income', 'Overheads', 'Depreciations and Amortizations',  'Unrealized FX', 'Forex','Financing result', 'Banking costs','Non-Recurring Other') THEN ytd_bundle_amount_bud ELSE 0 END)
        - SUM(CASE WHEN KPI_Name IN ('Unrealized FX') THEN  ytd_bundle_amount_bud ELSE 0 END)
        AS ytd_bundle_amount_bud,

        SUM(CASE WHEN KPI_Name IN ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge', 'Other Income', 'Overheads', 'Depreciations and Amortizations',  'Unrealized FX', 'Forex','Financing result', 'Banking costs','Non-Recurring Other') THEN ytd_conso_adjusted_amount_bud ELSE 0 END)
        - SUM(CASE WHEN KPI_Name IN ('Unrealized FX') THEN  ytd_conso_adjusted_amount_bud ELSE 0 END)
        AS ytd_conso_adjusted_amount_bud
    

    FROM Base_KPI
    WHERE KPI_Name IN ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge', 'Other Income', 'Overheads', 'Depreciations and Amortizations', 'Unrealized FX','Forex', 'Financing result', 'Banking costs','Non-Recurring Other')
    GROUP BY
        tkey_date,
        tkey_company,
        tkey_consolidation_period

    UNION ALL

    
    SELECT
        'Net Result' AS KPI_Name,
        tkey_date,
        tkey_company,
        tkey_consolidation_period,

        SUM(CASE WHEN KPI_Name IN ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge', 'Other Income', 'Overheads', 'Depreciations and Amortizations', 'Forex', 'Unrealized FX', 'Financing result', 'Banking costs','Non-Recurring Other', 'Taxes') THEN ytd_bundle_amount_act ELSE 0 END)
        -   SUM(CASE WHEN KPI_Name IN ('Unrealized FX') THEN ytd_bundle_amount_act ELSE 0 END)
        AS ytd_bundle_amount_act,

        SUM(CASE WHEN KPI_Name IN ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge', 'Other Income', 'Overheads', 'Depreciations and Amortizations', 'Forex', 'Unrealized FX', 'Financing result', 'Banking costs','Non-Recurring Other', 'Taxes') THEN ytd_conso_adjusted_amount_act ELSE 0 END)
        -   SUM(CASE WHEN KPI_Name IN ('Unrealized FX') THEN ytd_conso_adjusted_amount_act ELSE 0 END)
        AS ytd_conso_adjusted_amount_act,
    

        SUM(CASE WHEN KPI_Name IN ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge', 'Other Income', 'Overheads', 'Depreciations and Amortizations', 'Forex', 'Unrealized FX', 'Financing result', 'Banking costs','Non-Recurring Other', 'Taxes') THEN ytd_bundle_amount_fct ELSE 0 END)
        -   SUM(CASE WHEN KPI_Name IN ('Unrealized FX') THEN ytd_bundle_amount_fct ELSE 0 END)    
        AS ytd_bundle_amount_fct,


        SUM(CASE WHEN KPI_Name IN ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge', 'Other Income', 'Overheads', 'Depreciations and Amortizations', 'Forex', 'Unrealized FX', 'Financing result', 'Banking costs','Non-Recurring Other', 'Taxes') THEN ytd_conso_adjusted_amount_fct ELSE 0 END)
        -   SUM(CASE WHEN KPI_Name IN ('Unrealized FX') THEN ytd_conso_adjusted_amount_fct ELSE 0 END)  
        AS ytd_conso_adjusted_amount_fct,
    

        SUM(CASE WHEN KPI_Name IN ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge', 'Other Income', 'Overheads', 'Depreciations and Amortizations', 'Forex', 'Unrealized FX', 'Financing result', 'Banking costs','Non-Recurring Other', 'Taxes') THEN ytd_bundle_amount_bud ELSE 0 END)
        -   SUM(CASE WHEN KPI_Name IN ('Unrealized FX') THEN ytd_bundle_amount_bud ELSE 0 END)  
        AS ytd_bundle_amount_bud,


        SUM(CASE WHEN KPI_Name IN ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge', 'Other Income', 'Overheads', 'Depreciations and Amortizations', 'Forex', 'Unrealized FX', 'Financing result', 'Banking costs','Non-Recurring Other', 'Taxes') THEN ytd_conso_adjusted_amount_bud ELSE 0 END)
        -   SUM(CASE WHEN KPI_Name IN ('Unrealized FX') THEN ytd_conso_adjusted_amount_bud ELSE 0 END)  
        AS ytd_conso_adjusted_amount_bud
    

    FROM Base_KPI
    WHERE KPI_Name IN ('Turnover', 'COGS1', 'COGS2', 'Transactional financing cost', 'Realized FX on Natural Hedge', 'Other Income', 'Overheads', 'Depreciations and Amortizations', 'Forex', 'Unrealized FX', 'Financing result', 'Banking costs','Non-Recurring Other', 'Taxes')
    GROUP BY tkey_date, tkey_company, tkey_consolidation_period

    UNION ALL

    SELECT
        'L12MEBIT' AS KPI_Name,
        tkey_date,
        tkey_company,
        tkey_consolidation_period,
        L12MEBIT_bundle_amount_act as ytd_bundle_amount_act,
        L12MEBIT_conso_adjusted_amount_act as ytd_conso_adjusted_amount_act,
        L12MEBIT_bundle_amount_fct as ytd_bundle_amount_fct ,
        L12MEBIT_conso_adjusted_amount_fct as ytd_conso_adjusted_amount_fct,
        L12MEBIT_bundle_amount_bud as ytd_bundle_amount_bud,
        L12MEBIT_conso_adjusted_amount_bud as ytd_conso_adjusted_amount_bud

    FROM L12MEBIT_KPI

    UNION ALL

    SELECT
        'L3MTurnover' AS KPI_Name,
        tkey_date,
        tkey_company,
        tkey_consolidation_period,
        l3m_bundle_amount_act as ytd_bundle_amount_act,
        l3m_conso_adjusted_amount_act as ytd_conso_adjusted_amount_act,
        l3m_bundle_amount_fct as ytd_bundle_amount_fct ,
        l3m_conso_adjusted_amount_fct as ytd_conso_adjusted_amount_fct,
        l3m_bundle_amount_bud as ytd_bundle_amount_bud,
        l3m_conso_adjusted_amount_bud as ytd_conso_adjusted_amount_bud

    FROM L3M_KPI

    UNION

    SELECT
        'L3MCOGS1' AS KPI_Name,
        tkey_date,
        tkey_company,
        tkey_consolidation_period,
        l3mcogs1_bundle_amount_act as ytd_bundle_amount_act,
        l3mcogs1_conso_adjusted_amount_act as ytd_conso_adjusted_amount_act,
        l3mcogs1_bundle_amount_fct as ytd_bundle_amount_fct ,
        l3mcogs1_conso_adjusted_amount_fct as ytd_conso_adjusted_amount_fct,
        l3mcogs1_bundle_amount_bud as ytd_bundle_amount_bud,
        l3mcogs1_conso_adjusted_amount_bud as ytd_conso_adjusted_amount_bud

    FROM  L3M_COGS1_KPI

    UNION

    SELECT
        'L12MCI' AS KPI_Name,
        tkey_date,
        tkey_company,
        tkey_consolidation_period,
        l12mci_bundle_amount_act as ytd_bundle_amount_act,
        l12mci_conso_adjusted_amount_act as ytd_conso_adjusted_amount_act,
        l12mci_bundle_amount_fct as ytd_bundle_amount_fct ,
        l12mci_conso_adjusted_amount_fct as ytd_conso_adjusted_amount_fct,
        l12mci_bundle_amount_bud as ytd_bundle_amount_bud,
        l12mci_conso_adjusted_amount_bud as ytd_conso_adjusted_amount_bud

    FROM  L12M_CI
)

-- Step 5: Join final KPI values with KPI dimension to get KPI keys, and select all KPI amounts
SELECT  
    i.tkey_kpi,
    k.tkey_date,
    k.tkey_company,
    k.tkey_consolidation_period,
    ytd_bundle_amount_act,
    ytd_conso_adjusted_amount_act,
    ytd_bundle_amount_bud,
    ytd_conso_adjusted_amount_bud,
    ytd_bundle_amount_fct,
    ytd_conso_adjusted_amount_fct

FROM Final_KPIs k
INNER JOIN {{ ref('dim_kpi_items') }} i on k.KPI_Name = i.kpi_name