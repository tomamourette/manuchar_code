WITH source_product AS (
	SELECT 
		-- Keys
		CAST(ROW_NUMBER() OVER(ORDER BY prod.bkey_product) AS BIGINT) AS tkey_product,
		CAST(prod.bkey_product AS VARCHAR(255)) AS bkey_product,
		--Attributes
        CAST(prod.bkey_product AS VARCHAR(255)) AS product_code,
		CAST(prod.product_global_code AS VARCHAR(255)) AS product_global_code,
		CAST(prod.product_name AS VARCHAR(255)) AS product_name,
		CAST(prod.product_company AS VARCHAR(255)) AS product_company,
		CAST(prod.product_id AS VARCHAR(255)) AS product_id,
		-- History metadata
    	CAST(prod.valid_from AS DATETIME2(6)) AS valid_from,
      	CAST(prod.valid_to AS DATETIME2(6)) AS valid_to,
    	CAST(prod.is_current AS BIT) AS is_current
	FROM {{ ref('bv_product') }} prod
	WHERE prod.is_current = 1 -- add only the latest version
)

SELECT
	tkey_product,
	bkey_product,
    product_code,
	product_global_code,
	product_name,
	product_company,
	product_id,
	valid_from,
	valid_to,
	is_current
FROM source_product