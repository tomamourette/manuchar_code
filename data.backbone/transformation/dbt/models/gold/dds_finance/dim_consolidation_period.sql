{{ config(
    tags=['Group-FinancialStatements', 'Dimension', 'Consolidation Period']
) }}

WITH source_consolidation_period AS (
	SELECT 
		-- Keys
		CAST(ROW_NUMBER() OVER(ORDER BY cp.bkey_consolidation_period) AS BIGINT) AS tkey_consolidation_period,
		CAST(cp.bkey_consolidation_period AS VARCHAR(255)) AS bkey_consolidation_period,
		-- Attributes
		CAST(cp.consolidation_id AS BIGINT) AS consolidation_id,
		CAST(cp.bkey_consolidation_period AS VARCHAR(255)) AS consolidation_code,
		CAST(cp.consolidation_name AS VARCHAR(255)) AS consolidation_name,
		CAST(cp.consolidation_year AS INT) AS consolidation_year,
		CAST(cp.consolidation_month AS INT) AS consolidation_month,
		CAST(cp.consolidation_date AS DATETIME2(6)) AS consolidation_date,
		CAST(cp.consolidation_version AS INT) AS consolidation_version,
		CAST(cp.consolidation_category AS VARCHAR(255)) AS consolidation_category,
		CAST(
			COALESCE(
				cp.consolidation_category_description,
				CASE 
					WHEN cp.consolidation_category = 'ACT' THEN 'Actuals'
					WHEN cp.consolidation_category = 'BUD' THEN 'Budget'
					WHEN cp.consolidation_category = 'FOR' THEN 'Forecast'
					WHEN cp.consolidation_category = 'STA' THEN 'Statutory'
					WHEN cp.consolidation_category = 'TAX' THEN 'TAX Actuals'
					WHEN cp.consolidation_category = 'CDI' THEN 'CD Actuals'
					WHEN cp.consolidation_category = 'ITS' THEN 'ITS Actuals'
					WHEN cp.consolidation_category = 'ITB' THEN 'ITS Budget'
					WHEN cp.consolidation_category = 'CDB' THEN 'CD Budget'
					WHEN cp.consolidation_category = 'IFR' THEN 'IFRS'
					WHEN cp.consolidation_category = 'ITZ' THEN 'ITS IFRS'
					WHEN cp.consolidation_category = 'CDZ' THEN 'CD IFRS'
					WHEN cp.consolidation_category = 'ITT' THEN 'ITS TAX'
					WHEN cp.consolidation_category = 'CDT' THEN 'CD TAX'
					WHEN cp.consolidation_category = 'MGT' THEN 'Management'
					WHEN cp.consolidation_category = '5YP' THEN '5 Year Plan'
					ELSE cp.consolidation_category
				END
			) AS VARCHAR(255)
		) AS consolidation_category_description,
		CAST(cp.consolidation_scope AS VARCHAR(255)) AS consolidation_scope,
		CAST(cp.consolidation_l4l_scope AS VARCHAR(255)) AS [consolidation_L4L_scope],
		-- History metadata
		CAST(cp.valid_from AS DATETIME2(6)) AS valid_from,
      	CAST(cp.valid_to AS DATETIME2(6)) AS valid_to,
    	CAST(cp.is_current AS BIT) AS is_current
	FROM {{ ref('bv_consolidation_period') }} AS cp
	WHERE cp.is_current = 1 -- add only the latest version
	AND cp.consolidation_year >= '2018'
)

SELECT 
	tkey_consolidation_period,
	bkey_consolidation_period,
	consolidation_id,
	consolidation_code,
	consolidation_name,
	consolidation_year,
	consolidation_month,
	consolidation_date,
	consolidation_version,
	consolidation_category,
	consolidation_category_description,
	consolidation_scope,
	[consolidation_L4L_scope],
	valid_from,
	valid_to,
	is_current
FROM source_consolidation_period