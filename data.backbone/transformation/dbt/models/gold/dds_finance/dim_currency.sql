{{ config(
    tags=['Group-FinancialStatements', 'Dimension', 'Currency']
) }}

WITH source_currency AS (
	SELECT
		-- Keys
		CAST(ROW_NUMBER() OVER(ORDER BY cur.bkey_currency) AS BIGINT) AS tkey_currency,
		CAST(cur.bkey_currency AS VARCHAR(255)) AS bkey_currency,
		-- Attributes	
		CAST(cur.bkey_currency AS VARCHAR(255)) AS currency_code,
		CAST(cur.currency_name AS VARCHAR(255)) AS currency_description,
		-- History metadata
		CAST(cur.valid_from AS DATETIME2(6)) AS valid_from,
		CAST(cur.valid_to AS DATETIME2(6)) AS valid_to,
		CAST(cur.is_current AS BIT) AS is_current
	FROM {{ ref('bv_currency') }} AS cur
	WHERE cur.is_current = 1 -- add only the latest version
)

SELECT 
	tkey_currency,
	bkey_currency,
	currency_code,
	currency_description,
	valid_from,
	valid_to,
	is_current
FROM source_currency