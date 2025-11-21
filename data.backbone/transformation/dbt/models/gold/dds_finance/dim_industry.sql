{{ config(
    tags=['Group-FinancialStatements', 'Dimension', 'Industry']
) }}

WITH source_industry AS (
	SELECT
		-- Keys
		CAST(ROW_NUMBER() OVER(ORDER BY ind.bkey_industry) AS BIGINT) AS tkey_industry,
		CAST(ind.bkey_industry AS VARCHAR(255)) AS bkey_industry,	
		-- Attributes
		CAST(ind.bkey_industry AS VARCHAR(255)) AS industry_code,
		CAST(ind.industry_name AS VARCHAR(255)) AS industry_description,
		CAST(ind.industry_group AS VARCHAR(255)) AS industry_group,
		-- History metadata
		CAST(ind.valid_from AS DATETIME2(6)) AS valid_from,
		CAST(ind.valid_to AS DATETIME2(6)) AS valid_to,
		CAST(ind.is_current AS BIT) AS is_current
	FROM {{ ref('bv_industry') }} AS ind
	WHERE ind.is_current = 1 -- add only the latest version
)

SELECT 
	tkey_industry,
	bkey_industry,	
	industry_code,
	industry_description,
	industry_group,
	valid_from,
	valid_to,
	is_current
FROM source_industry