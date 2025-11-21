{{ config(
    tags=['Group-FinancialStatements', 'Fact', 'Financial Statements']
) }}

-- Mapping table for Volume Accounts
WITH volume_accounts AS (
	SELECT 
        bkey_account
    FROM {{ ref('bv_account') }}
    WHERE bkey_account LIKE '%QMT'
    AND is_current = 1
),
-- Mapping table for FTE Accounts
fte_accounts AS (
    SELECT 
        bkey_account 
    FROM {{ ref('bv_account') }}
    WHERE bkey_account LIKE '800%'
    AND is_current = 1
),
-- Mapping table for Holidays per Country
public_holidays AS (
    SELECT 
        country_region_code AS country_code,
        MONTH(date) AS holiday_month,
        YEAR(date) AS holiday_year,
        COUNT(DISTINCT date) AS holidays_in_month,
        COUNT(DISTINCT CASE 
                            WHEN DATEPART(WEEKDAY, date) NOT IN (1, 7) 
                            THEN date 
                            END) AS non_weekend_holidays_in_month
    FROM {{ ref('bv_public_holiday') }}
    GROUP BY 
		country_region_code, 
		MONTH(date),
		YEAR(date)
),
-- Mapping table for Company Participation Percentage for FTE and Volume Amounts
company_participation_percentage AS (
    SELECT
        dat.month_key,
        com.bkey_company,
        MAX(com.company_group_percentage) AS company_group_percentage,
        LAG(MAX(com.company_group_percentage)) OVER (PARTITION BY com.bkey_company ORDER BY dat.month_key) AS prev_company_group_percentage
    FROM {{ ref('dim_date') }} dat
    INNER JOIN {{ ref('dim_company') }} com
        ON com.valid_from <= dat.date OR com.valid_from IS NULL
       AND (com.valid_to > dat.date OR com.valid_to IS NULL)
    WHERE dat.year >= '2018'
    GROUP BY
        com.bkey_company,
        dat.month_key
    HAVING 
    	MAX(com.company_group_percentage) IS NOT NULL
),
-- Mapping table for FTE First Reporting Months
fte_first_reporting_months AS (
	SELECT
		csa.consolidated_company AS bkey_company,
		csp.consolidation_year,
		csp.consolidation_category,
		csp.consolidation_version,
		csa.consolidated_account AS bkey_account,
		MIN(csp.consolidation_month) AS first_consolidation_month
	FROM {{ ref('bv_consolidated_amount') }} csa
	LEFT JOIN {{ ref('bv_consolidation_period') }} csp
        ON csa.consolidated_consolidation_period = csp.bkey_consolidation_period
	WHERE csp.consolidation_year >= '2018' AND csa.consolidated_account IN (SELECT bkey_account FROM fte_accounts)
  	GROUP BY
		csa.consolidated_company,
		csp.consolidation_year,
		csp.consolidation_category,
		csp.consolidation_version,
		csa.consolidated_account
),
-- Devide YTD Amount Over Reporting Groups Using Journal Mapping & Group by Grain
ytd_reporting_groups AS (
    SELECT 
        -- Grain
        csa.consolidated_account AS bkey_account,
        csa.consolidated_consolidation_period AS bkey_consolidation_period,
        csa.consolidated_company AS bkey_company,
        csa.consolidated_currency AS bkey_currency,
        csa.consolidated_partner_company AS bkey_partner_company,
        csa.consolidated_industry AS bkey_industry,
        -- Numerical Amounts
        ---- Basic YTD totals
        SUM(csa.consolidated_amount) AS ytd_amount,
        SUM(csa.consolidated_bundle_local_amount) AS ytd_bundle_local_in_local_currency_amount,
        SUM(csa.consolidated_bundle_local_adjustment_amount) AS ytd_bundle_local_adjustment_in_local_currency_amount,
        -- Allocation
        SUM(CASE 
            WHEN jm.allocation = 1 AND fte.bkey_account IS NOT NULL THEN 
                ((csp.consolidation_month - fftm.first_consolidation_month + 1) * csa.consolidated_amount)
                * cpp.prev_company_group_percentage / NULLIF(cpp.company_group_percentage, 0)
            WHEN jm.allocation = 1 AND vol.bkey_account IS NOT NULL THEN 
                csa.consolidated_amount * cpp.prev_company_group_percentage / NULLIF(cpp.company_group_percentage, 0)
            WHEN jm.allocation = 1 THEN 
                csa.consolidated_amount
            ELSE 0.00 
        END) AS ytd_allocation_amount,
        -- Bundle
        SUM(CASE 
            WHEN jm.bundle = 1 AND fte.bkey_account IS NOT NULL THEN 
                ((csp.consolidation_month - fftm.first_consolidation_month + 1) * csa.consolidated_amount)
                * cpp.prev_company_group_percentage / NULLIF(cpp.company_group_percentage, 0)
            WHEN jm.bundle = 1 AND vol.bkey_account IS NOT NULL THEN 
                csa.consolidated_amount * cpp.prev_company_group_percentage / NULLIF(cpp.company_group_percentage, 0)
            WHEN jm.bundle = 1 THEN 
                csa.consolidated_amount
            ELSE 0.00 
        END) AS ytd_bundle_amount,
        -- Conso Adjusted
        SUM(CASE 
            WHEN jm.conso_adjusted = 1 AND fte.bkey_account IS NOT NULL THEN 
                ((csp.consolidation_month - fftm.first_consolidation_month + 1) * csa.consolidated_amount)
                * cpp.prev_company_group_percentage / NULLIF(cpp.company_group_percentage, 0)
            WHEN jm.conso_adjusted = 1 AND vol.bkey_account IS NOT NULL THEN 
                csa.consolidated_amount * cpp.prev_company_group_percentage / NULLIF(cpp.company_group_percentage, 0)
            WHEN jm.conso_adjusted = 1 THEN 
                csa.consolidated_amount
            ELSE 0.00 
        END) AS ytd_conso_adjusted_amount,
        -- Conso Legal
        SUM(CASE 
            WHEN jm.conso_legal = 1 AND fte.bkey_account IS NOT NULL THEN 
                ((csp.consolidation_month - fftm.first_consolidation_month + 1) * csa.consolidated_amount)
                * cpp.prev_company_group_percentage / NULLIF(cpp.company_group_percentage, 0)
            WHEN jm.conso_legal = 1 AND vol.bkey_account IS NOT NULL THEN 
                csa.consolidated_amount * cpp.prev_company_group_percentage / NULLIF(cpp.company_group_percentage, 0)
            WHEN jm.conso_legal = 1 THEN 
                csa.consolidated_amount
            ELSE 0.00 
        END) AS ytd_conso_legal_amount,
        -- Intercompany
        SUM(CASE 
            WHEN jm.intercompany = 1 AND fte.bkey_account IS NOT NULL THEN 
                ((csp.consolidation_month - fftm.first_consolidation_month + 1) * csa.consolidated_amount)
                * cpp.prev_company_group_percentage / NULLIF(cpp.company_group_percentage, 0)
            WHEN jm.intercompany = 1 AND vol.bkey_account IS NOT NULL THEN 
                csa.consolidated_amount * cpp.prev_company_group_percentage / NULLIF(cpp.company_group_percentage, 0)
            WHEN jm.intercompany = 1 THEN 
                csa.consolidated_amount
            ELSE 0.00 
        END) AS ytd_intercompany_amount,
        -- Manual
        SUM(CASE 
            WHEN jm.manual = 1 AND fte.bkey_account IS NOT NULL THEN 
                ((csp.consolidation_month - fftm.first_consolidation_month + 1) * csa.consolidated_amount)
                * cpp.prev_company_group_percentage / NULLIF(cpp.company_group_percentage, 0)
            WHEN jm.manual = 1 AND vol.bkey_account IS NOT NULL THEN 
                csa.consolidated_amount * cpp.prev_company_group_percentage / NULLIF(cpp.company_group_percentage, 0)
            WHEN jm.manual = 1 THEN 
                csa.consolidated_amount
            ELSE 0.00 
        END) AS ytd_manual_amount,
        -- Technical Eliminations
        SUM(CASE 
            WHEN jm.technical_eliminations = 1 AND fte.bkey_account IS NOT NULL THEN 
                ((csp.consolidation_month - fftm.first_consolidation_month + 1) * csa.consolidated_amount)
                * cpp.prev_company_group_percentage / NULLIF(cpp.company_group_percentage, 0)
            WHEN jm.technical_eliminations = 1 AND vol.bkey_account IS NOT NULL THEN 
                csa.consolidated_amount * cpp.prev_company_group_percentage / NULLIF(cpp.company_group_percentage, 0)
            WHEN jm.technical_eliminations = 1 THEN 
                csa.consolidated_amount
            ELSE 0.00 
        END) AS ytd_technical_eliminations_amount,
        -- Volume
        SUM(CASE 
            WHEN vol.bkey_account IS NOT NULL THEN 
                csa.consolidated_amount 
            ELSE 0.00 
        END) * cpp.prev_company_group_percentage / NULLIF(cpp.company_group_percentage, 0) AS ytd_volume_amount,
        -- FTE
        SUM(CASE 
            WHEN fte.bkey_account IS NOT NULL THEN 
                (csp.consolidation_month - fftm.first_consolidation_month + 1) * csa.consolidated_amount 
            ELSE 0.00 
        END) * cpp.prev_company_group_percentage / NULLIF(cpp.company_group_percentage, 0) AS ytd_fte_amount,  
        SUM(CASE 
            WHEN fte.bkey_account IS NOT NULL THEN 
                csa.consolidated_amount 
            ELSE 0.00 
        END) * cpp.prev_company_group_percentage / NULLIF(cpp.company_group_percentage, 0) AS ytd_fte_avg_amount   
    FROM {{ ref('bv_consolidated_amount') }} csa
    LEFT JOIN {{ ref('dim_consolidation_period') }} csp
        ON csa.consolidated_consolidation_period = csp.bkey_consolidation_period
    LEFT JOIN {{ ref('bv_journal_mapping') }} jm 
        ON jm.bkey_journal_mapping = CONCAT(csa.consolidated_journal_type, csa.consolidated_journal_category)
    LEFT JOIN volume_accounts vol 
        ON vol.bkey_account = csa.consolidated_account
    LEFT JOIN fte_accounts fte 
        ON fte.bkey_account = csa.consolidated_account
    LEFT JOIN company_participation_percentage cpp
    	ON cpp.bkey_company = csa.consolidated_company AND cpp.month_key = LEFT(csa.consolidated_consolidation_period, 6)
    LEFT JOIN fte_first_reporting_months fftm
        ON fftm.bkey_company = csa.consolidated_company 
        AND fftm.consolidation_year = csp.consolidation_year 
        AND fftm.consolidation_category = csp.consolidation_category 
        AND fftm.consolidation_version = csp.consolidation_version 
        AND fftm.bkey_account = csa.consolidated_account
    WHERE csp.consolidation_year >= '2018'
    GROUP BY 
        csa.consolidated_account,
        csa.consolidated_consolidation_period,
        csa.consolidated_company,
        csa.consolidated_currency,
        csa.consolidated_partner_company,
        csa.consolidated_industry,
        cpp.company_group_percentage, cpp.prev_company_group_percentage
),
-- Calculate MTD Amounts Using LEAD Function PARTITIONED BY Grain
{# monthly_reporting_groups AS ( 
    SELECT
        -- Grain 
        ytd.bkey_account,
        ytd.bkey_consolidation_period,
        ytd.bkey_company,
        ytd.bkey_currency,
        ytd.bkey_partner_company,
        ytd.bkey_industry,
        -- Numerical Amounts 
        ytd.[ytd_amount] - LAG(ytd.[ytd_amount], 1, 0) OVER (PARTITION BY csp.consolidation_year, csp.consolidation_category, csp.consolidation_version, ytd.bkey_account, ytd.bkey_company, ytd.bkey_currency, ytd.bkey_partner_company, ytd.bkey_industry ORDER BY csp.consolidation_month) AS [monthly_amount],
        ytd.[ytd_bundle_local_in_local_currency_amount] - LAG(ytd.[ytd_bundle_local_in_local_currency_amount], 1, 0) OVER (PARTITION BY csp.consolidation_year, csp.consolidation_category, csp.consolidation_version, ytd.bkey_account, ytd.bkey_company, ytd.bkey_currency, ytd.bkey_partner_company, ytd.bkey_industry ORDER BY csp.consolidation_month) AS [monthly_bundle_local_in_local_currency_amount],
        ytd.[ytd_bundle_local_adjustment_in_local_currency_amount] - LAG(ytd.[ytd_bundle_local_adjustment_in_local_currency_amount], 1, 0) OVER (PARTITION BY csp.consolidation_year, csp.consolidation_category, csp.consolidation_version, ytd.bkey_account, ytd.bkey_company, ytd.bkey_currency, ytd.bkey_partner_company, ytd.bkey_industry ORDER BY csp.consolidation_month) AS [monthly_bundle_local_adjustment_in_local_currency_amount],
        ytd.[ytd_allocation_amount] - LAG(ytd.[ytd_allocation_amount], 1, 0) OVER (PARTITION BY csp.consolidation_year, csp.consolidation_category, csp.consolidation_version, ytd.bkey_account, ytd.bkey_company, ytd.bkey_currency, ytd.bkey_partner_company, ytd.bkey_industry ORDER BY csp.consolidation_month) AS [monthly_allocation_amount],
        ytd.[ytd_bundle_amount] - LAG(ytd.[ytd_bundle_amount], 1, 0) OVER (PARTITION BY csp.consolidation_year, csp.consolidation_category, csp.consolidation_version, ytd.bkey_account, ytd.bkey_company, ytd.bkey_currency, ytd.bkey_partner_company, ytd.bkey_industry ORDER BY csp.consolidation_month) AS [monthly_bundle_amount],
        ytd.[ytd_conso_adjusted_amount] - LAG(ytd.[ytd_conso_adjusted_amount], 1, 0) OVER (PARTITION BY csp.consolidation_year, csp.consolidation_category, csp.consolidation_version, ytd.bkey_account, ytd.bkey_company, ytd.bkey_currency, ytd.bkey_partner_company, ytd.bkey_industry ORDER BY csp.consolidation_month) AS [monthly_conso_adjusted_amount],
        ytd.[ytd_conso_legal_amount] - LAG(ytd.[ytd_conso_legal_amount], 1, 0) OVER (PARTITION BY csp.consolidation_year, csp.consolidation_category, csp.consolidation_version, ytd.bkey_account, ytd.bkey_company, ytd.bkey_currency, ytd.bkey_partner_company, ytd.bkey_industry ORDER BY csp.consolidation_month) AS [monthly_conso_legal_amount],
        ytd.[ytd_intercompany_amount] - LAG(ytd.[ytd_intercompany_amount], 1, 0) OVER (PARTITION BY csp.consolidation_year, csp.consolidation_category, csp.consolidation_version, ytd.bkey_account, ytd.bkey_company, ytd.bkey_currency, ytd.bkey_partner_company, ytd.bkey_industry ORDER BY csp.consolidation_month) AS [monthly_intercompany_amount],
        ytd.[ytd_manual_amount] - LAG(ytd.[ytd_manual_amount], 1, 0) OVER (PARTITION BY csp.consolidation_year, csp.consolidation_category, csp.consolidation_version, ytd.bkey_account, ytd.bkey_company, ytd.bkey_currency, ytd.bkey_partner_company, ytd.bkey_industry ORDER BY csp.consolidation_month) AS [monthly_manual_amount],
        ytd.[ytd_technical_eliminations_amount] - LAG(ytd.[ytd_technical_eliminations_amount], 1, 0) OVER (PARTITION BY csp.consolidation_year, csp.consolidation_category, csp.consolidation_version, ytd.bkey_account, ytd.bkey_company, ytd.bkey_currency, ytd.bkey_partner_company, ytd.bkey_industry ORDER BY csp.consolidation_month) AS [monthly_technical_eliminations_amount],
        ytd.[ytd_volume_amount] - LAG(ytd.[ytd_volume_amount], 1, 0) OVER (PARTITION BY csp.consolidation_year, csp.consolidation_category, csp.consolidation_version, ytd.bkey_account, ytd.bkey_company, ytd.bkey_currency, ytd.bkey_partner_company, ytd.bkey_industry ORDER BY csp.consolidation_month) AS [monthly_volume_amount],
        ytd.[ytd_fte_amount] - LAG(ytd.[ytd_fte_amount], 1, 0) OVER (PARTITION BY csp.consolidation_year, csp.consolidation_category, csp.consolidation_version, ytd.bkey_account, ytd.bkey_company, ytd.bkey_currency, ytd.bkey_partner_company, ytd.bkey_industry ORDER BY csp.consolidation_month) AS [monthly_fte_amount],
        ytd.[ytd_fte_avg_amount] - LAG(ytd.[ytd_fte_avg_amount], 1, 0) OVER (PARTITION BY csp.consolidation_year, csp.consolidation_category, csp.consolidation_version, ytd.bkey_account, ytd.bkey_company, ytd.bkey_currency, ytd.bkey_partner_company, ytd.bkey_industry ORDER BY csp.consolidation_month) AS [monthly_fte_avg_amount]
    FROM ytd_reporting_groups ytd
    LEFT JOIN {{ ref('dim_consolidation_period') }} csp
        ON ytd.bkey_consolidation_period = csp.bkey_consolidation_period 
), #}
-- Calculate Actual Amount of Working Days Based on Company Country And Consolidation Period BY Grain
working_days AS (
    SELECT 
        -- Grain
        ytd.bkey_account,
        ytd.bkey_consolidation_period,
        ytd.bkey_company,
        ytd.bkey_currency,
        ytd.bkey_partner_company,
        ytd.bkey_industry,
        -- Working Days
        dat.number_of_work_days_in_month - COALESCE(pbh.non_weekend_holidays_in_month, 0) AS actual_workday_holidays_in_workweek
    FROM ytd_reporting_groups ytd
    LEFT JOIN {{ ref('dim_consolidation_period') }} csp
        ON ytd.bkey_consolidation_period = csp.bkey_consolidation_period
    LEFT JOIN {{ ref('dim_date') }} dat
        ON FORMAT(EOMONTH(CONVERT(date, LEFT(csp.bkey_consolidation_period, 6) + '01')), 'yyyyMMdd') = dat.bkey_date
    LEFT JOIN {{ ref('dim_company') }} com
        ON ytd.bkey_company = com.bkey_company
        AND com.is_current = 1
    LEFT JOIN public_holidays pbh
        ON com.company_country_code = pbh.country_code 
        AND MONTH(dat.date) = pbh.holiday_month
        AND YEAR(dat.date) = pbh.holiday_year
)


--- FEATURE 75170: CR L4L copy bundle actuals 900 version to conso adjusted actuals & forecast bundle

SELECT 
    -- Date Key
    dat.tkey_date,
    -- Dimension Tkeys
    acc.tkey_account,
    csp.tkey_consolidation_period,
    com.tkey_company,
    pcom.tkey_company AS tkey_partner_company,
    cur.tkey_currency,
    ind.tkey_industry,
    -- ytd Reporting Group Amounts
    CAST(ytd.ytd_amount AS DECIMAL(18, 2)) AS amount,
    CAST(ytd.ytd_bundle_local_adjustment_in_local_currency_amount AS DECIMAL(18, 2)) AS bundle_local_adjustment_in_local_currency_amount,
    CAST(ytd.ytd_bundle_local_in_local_currency_amount AS DECIMAL(18, 2)) AS bundle_local_in_local_currency_amount,
    CAST(ytd.ytd_allocation_amount AS DECIMAL(18, 2)) AS allocation_amount,

    --- 2025/10/31: UAT feedback to adjust L4L Balance Sheet from 202502 to 0 for Bundle and Conso Adjusted Bundle
    -- CAST(ytd.ytd_bundle_amount AS DECIMAL(18, 2)) AS bundle_amount,
    CAST(
        CASE 
            WHEN csp.consolidation_L4L_scope LIKE 'Like4Like%'
                AND acc.account_type = 'Balance Sheet'
                AND csp.consolidation_month <> 1   -- only first month keeps value
            THEN 0
            ELSE ytd.ytd_bundle_amount
        END AS DECIMAL(18, 2)
    ) AS bundle_amount,

    
    --- FEATURE 75170: CR L4L copy bundle actuals 900 version to conso adjusted actuals & forecast bundle
    -- CAST(ytd.ytd_conso_adjusted_amount AS DECIMAL(18, 2)) AS conso_adjusted_amount,
    CAST(
        CASE 
            -- L4L Balance Sheet: from 2024-02 onward all months except January -> 0
            WHEN csp.consolidation_L4L_scope LIKE 'Like4Like%' 
                AND acc.account_type = 'Balance Sheet'
                AND csp.consolidation_month <> 1
            THEN 0

            -- L4L: if bundle has a value, use it
            WHEN csp.consolidation_L4L_scope LIKE 'Like4Like%' 
                AND ytd.ytd_bundle_amount <> 0
            THEN
                ytd.ytd_bundle_amount 

            -- Fallback: use conso adjusted amount
            ELSE 
                ytd.ytd_conso_adjusted_amount
        END AS DECIMAL(18, 2)
    ) AS conso_adjusted_amount,
    
    
    CAST(ytd.ytd_conso_legal_amount AS DECIMAL(18, 2)) AS conso_legal_amount,
    CAST(ytd.ytd_intercompany_amount AS DECIMAL(18, 2)) AS intercompany_amount,
    CAST(ytd.ytd_manual_amount AS DECIMAL(18, 2)) AS manual_amount,
    CAST(ytd.ytd_technical_eliminations_amount AS DECIMAL(18, 2)) AS technical_eliminations_amount,
    CAST(ytd.ytd_volume_amount AS DECIMAL(18, 2)) AS volume_amount,
    CAST(ytd.ytd_fte_amount AS DECIMAL(18, 2)) AS fte_amount,
    CAST(ytd.ytd_fte_avg_amount AS DECIMAL(18, 2)) AS fte_avg_amount,
    -- Working Days
    wda.actual_workday_holidays_in_workweek,
    --- BKey_Consolidation Period
    ytd.bkey_consolidation_period

FROM ytd_reporting_groups ytd
LEFT JOIN {{ ref('dim_consolidation_period') }} csp
    ON ytd.bkey_consolidation_period = csp.bkey_consolidation_period
LEFT JOIN {{ ref('dim_date') }} dat
    ON FORMAT(EOMONTH(CONVERT(date, LEFT(csp.bkey_consolidation_period, 6) + '01')), 'yyyyMMdd') = dat.bkey_date
LEFT JOIN {{ ref('dim_account') }} acc
    ON ytd.bkey_account = acc.bkey_account
LEFT JOIN {{ ref('dim_company') }} com
    ON ytd.bkey_company = com.bkey_company
    AND (com.valid_from <= dat.date 
        OR com.valid_from IS NULL)
    AND (com.valid_to > dat.date 
        OR com.valid_to IS NULL)
LEFT JOIN {{ ref('dim_company') }} pcom
    ON ytd.bkey_partner_company = pcom.bkey_company
    AND (pcom.valid_from <= dat.date 
        OR pcom.valid_from IS NULL)
    AND (pcom.valid_to > dat.date
        OR pcom.valid_to IS NULL)
LEFT JOIN {{ ref('dim_currency') }} cur
    ON ytd.bkey_currency = cur.bkey_currency
LEFT JOIN {{ ref('dim_industry') }} ind
    ON ytd.bkey_industry = ind.bkey_industry
LEFT JOIN working_days wda
    ON ytd.bkey_account = wda.bkey_account 
    AND ytd.bkey_consolidation_period = wda.bkey_consolidation_period 
    AND ytd.bkey_company = wda.bkey_company 
    AND ytd.bkey_currency = wda.bkey_currency 
    AND ytd.bkey_partner_company = wda.bkey_partner_company
    AND ytd.bkey_industry = wda.bkey_industry 