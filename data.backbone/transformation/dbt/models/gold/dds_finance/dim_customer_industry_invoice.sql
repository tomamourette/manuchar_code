WITH source_customer_industry_invoice AS (
	SELECT
		-- Keys
		CAST(ROW_NUMBER() OVER(ORDER BY ind.bkey_customer_industry_invoice) AS BIGINT) AS tkey_customer_industry_invoice,
		CAST(ind.bkey_customer_industry_invoice AS VARCHAR(255)) AS bkey_customer_industry_invoice,	
		-- Attributes
		CAST(ind.bkey_customer_industry_invoice AS VARCHAR(255)) AS customer_industry_invoice_code,
		CAST(ind.customer_industry_invoice_name AS VARCHAR(255)) AS customer_industry_invoice_description,
		CAST(ind.customer_industry_invoice_group AS VARCHAR(255)) AS customer_industry_invoice_group,
		-- History metadata
		CAST(ind.valid_from AS DATETIME2(6)) AS valid_from,
		CAST(ind.valid_to AS DATETIME2(6)) AS valid_to,
		CAST(ind.is_current AS BIT) AS is_current
	FROM {{ ref('bv_customer_industry_invoice') }} AS ind
	WHERE ind.is_current = 1 -- add only the latest version
)

SELECT 
	tkey_customer_industry_invoice,
	bkey_customer_industry_invoice,	
	customer_industry_invoice_code,
	customer_industry_invoice_description,
	customer_industry_invoice_group,
	valid_from,
	valid_to,
	is_current
FROM source_customer_industry_invoice