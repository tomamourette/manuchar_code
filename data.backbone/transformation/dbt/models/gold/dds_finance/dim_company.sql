{{ config(
    tags=['Group-FinancialStatements', 'Dimension', 'Company']
) }}

WITH source_company AS (
	SELECT 
		-- Keys
		CAST(ROW_NUMBER() OVER(ORDER BY cpy.bkey_company) AS BIGINT) AS tkey_company,
		CAST(cpy.bkey_company AS VARCHAR(255)) AS bkey_company,
		--Attributes
		CAST(cpy.bkey_company AS VARCHAR(255)) AS company_code,
		CAST(cpy.company_name AS VARCHAR(255)) AS company_name,
		CAST(cpy.company_consolidation_method AS VARCHAR(255)) AS consolidation_method,
		CAST(cpy.company_active_code AS BIT) AS company_active_flag,
		CAST(cpy.company_local_currency AS VARCHAR(255)) AS company_local_currency,
		CAST(cpy.company_home_currency AS VARCHAR(255)) AS company_home_currency,
		CAST(cur.currency_name AS VARCHAR(255)) AS company_home_currency_description,
		CAST(cpy.company_country_code AS VARCHAR(255)) AS company_country_code,
		CAST(cpy.company_group_percentage AS DECIMAL(5, 2)) AS company_group_percentage,
		CAST(cpy.company_minor_percentage AS DECIMAL(5, 2)) AS company_minor_percentage,
		CAST(cpy.company_group_control_percentage AS DECIMAL(5, 2)) AS company_group_control_percentage,
		CAST(cpy.company_tree_level_1 AS VARCHAR(255)) AS company_tree_level_1,
		CAST(cpy.company_tree_level_2 AS VARCHAR(255)) AS company_tree_level_2,
		CAST(cpy.company_min_reporting_period AS INT) AS company_min_reporting_period,
		CAST(cou.country_name AS VARCHAR(255)) AS company_country_name,
		CAST(CASE
				WHEN cou.country_sort = 'UNK' THEN NULL
				ELSE cou.country_sort
			END AS INT) AS company_country_sort,
		CAST(cou.country_iso_code AS VARCHAR(255)) AS company_iso_code,
		CAST(CASE 
				WHEN cou.country_region_level_2 = 'Brazil' THEN 'Brazil'
				WHEN cou.country_region_level_2 = 'South America' THEN 'South America'
				WHEN cou.country_region_level_2 IN ('Central America', 'Caribs', 'North America') THEN 'Other Americas & Caribs'
				WHEN cou.country_region_level_2 IN ('Europe', 'Middle East', 'Africa', 'Mediterranean', 'Middle East North Africa') THEN 'EMEA'
				WHEN cou.country_region_level_2 IN ('Asia', 'Central Asia') THEN 'Asia'
				ELSE 'Unmapped'
			END AS VARCHAR(255)) AS company_region_level_1,
		CAST(CASE 
				WHEN cou.country_region_level_2 = 'Brazil' THEN 1
				WHEN cou.country_region_level_2 = 'South America' THEN 2
				WHEN cou.country_region_level_2 IN ('Central America', 'Caribs', 'North America') THEN 3
				WHEN cou.country_region_level_2 IN ('Europe', 'Middle East', 'Africa', 'Mediterranean', 'Middle East North Africa') THEN 4
				WHEN cou.country_region_level_2 IN ('Asia', 'Central Asia') THEN 5
				ELSE NULL
			END AS INT) AS company_region_level_1_sort,
		CAST(cou.country_region_level_2 AS VARCHAR(255)) AS company_region_level_2,
		CAST(cou.country_region_level_2_sort AS INT) AS company_region_level_2_sort,
		-- History metadata
    	CAST(cpy.valid_from AS DATETIME2(6)) AS valid_from,
      	CAST(cpy.valid_to AS DATETIME2(6)) AS valid_to,
    	CAST(cpy.is_current AS BIT) AS is_current
	FROM {{ ref('bv_company') }} cpy
	LEFT JOIN {{ ref('bv_currency') }} cur ON cpy.company_home_currency = cur.bkey_currency AND cur.is_current = 1
	LEFT JOIN {{ ref('bv_country') }} cou ON cpy.company_country_code = cou.bkey_country AND cou.is_current = 1
	--WHERE cpy.is_current = 1 -- add only the latest version
)

SELECT
	tkey_company,
	bkey_company,
	company_code,
	company_name,
	consolidation_method,
	company_active_flag,
	company_local_currency,
	company_home_currency,
	company_home_currency_description,
	company_country_code,
	company_group_percentage,
	company_minor_percentage,
	company_group_control_percentage,
	company_tree_level_1,
	company_tree_level_2,
	company_min_reporting_period,
	company_country_name,
	company_country_sort,
	company_iso_code,
	company_region_level_1,
	company_region_level_1_sort,
	company_region_level_2,
	company_region_level_2_sort,
	valid_from,
	valid_to,
	is_current
FROM source_company