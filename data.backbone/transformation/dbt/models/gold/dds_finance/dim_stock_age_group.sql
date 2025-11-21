WITH source_stock_age_group AS (
	SELECT 
		-- Keys
		CAST(ROW_NUMBER() OVER(ORDER BY ag.bkey_stock_age_group) AS BIGINT) AS tkey_stock_age_group,
		CAST(ag.bkey_stock_age_group AS VARCHAR(255)) AS bkey_stock_age_group,
		-- Attributes
		CAST(ag.bkey_stock_age_group AS VARCHAR(255)) AS stock_age_group_code,
		CAST(ag.stock_age_group_name AS VARCHAR(255)) AS stock_age_group_name,
        CAST(ag.stock_age_group_id AS VARCHAR(255)) AS stock_age_group_id,
        CAST(ag.stock_age_group_min_days AS VARCHAR(255)) AS stock_age_group_min_days,
        CAST(ag.stock_age_group_max_days AS VARCHAR(255)) AS stock_age_group_max_days,
        CAST(ag.stock_age_group_sort AS VARCHAR(255)) AS stock_age_group_sort,
		-- History metadata
		CAST(ag.valid_from AS DATETIME2(6)) AS valid_from,
	  	CAST(ag.valid_to AS DATETIME2(6)) AS valid_to,
		CAST(ag.is_current AS BIT) AS is_current
	FROM {{ ref('bv_stock_age_group') }} AS ag
	WHERE ag.is_current = 1 -- add only the latest version
)

SELECT 
	tkey_stock_age_group,
	bkey_stock_age_group,
	stock_age_group_code,
	stock_age_group_name,
    stock_age_group_id,
    stock_age_group_min_days,
    stock_age_group_max_days,
    stock_age_group_sort,
	valid_from,
	valid_to,
	is_current
FROM source_stock_age_group