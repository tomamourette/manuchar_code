WITH source_product AS (
	SELECT 
		-- Keys
		CAST(ROW_NUMBER() OVER(ORDER BY prod.bkey_product_global) AS BIGINT) AS tkey_product_global,
		CAST(prod.bkey_product_global AS VARCHAR(255)) AS bkey_product_global,
		--Attributes
		CAST(prod.bkey_product_global AS VARCHAR(255)) AS product_global_code,
		CAST(prod.product_group AS VARCHAR(255)) AS product_group,
		CAST(prod.product_group_category AS VARCHAR(255)) AS product_group_category,
        CAST(prod.product_group_subcategory AS VARCHAR(255)) AS product_group_subcategory,
        CAST(prod.product_business_unit AS VARCHAR(255)) AS product_business_unit,
		CAST(prod.product_global_name AS VARCHAR(255)) AS product_global_name,
		CAST(prod.product_core AS BIT) AS product_core,
		-- History metadata
    	CAST(prod.valid_from AS DATETIME2(6)) AS valid_from,
      	CAST(prod.valid_to AS DATETIME2(6)) AS valid_to,
    	CAST(prod.is_current AS BIT) AS is_current
	FROM {{ ref('bv_product_global') }} prod
	WHERE prod.is_current = 1 -- add only the latest version
)

SELECT
	tkey_product_global,
	bkey_product_global,
	product_global_code,
	product_group,
	product_group_category,
    product_group_subcategory,
    product_business_unit,
	product_global_name,
	product_core,
	valid_from,
	valid_to,
	is_current
FROM source_product