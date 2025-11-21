WITH source_cost_center AS (
	SELECT 
		-- Keys
		CAST(ROW_NUMBER() OVER(ORDER BY cc.bkey_cost_center) AS BIGINT) AS tkey_cost_center,
		CAST(cc.bkey_cost_center AS VARCHAR(255)) AS bkey_cost_center,
		-- Attributes
		CAST(cc.bkey_cost_center AS VARCHAR(255)) AS cost_center_code,
		CAST(cc.cost_center_description AS VARCHAR(255)) AS cost_center_description,
		-- History metadata
		CAST(cc.valid_from AS DATETIME2(6)) AS valid_from,
	  	CAST(cc.valid_to AS DATETIME2(6)) AS valid_to,
		CAST(cc.is_current AS BIT) AS is_current
	FROM {{ ref('bv_cost_center') }} AS cc
	WHERE cc.is_current = 1 -- add only the latest version
)

SELECT 
	tkey_cost_center,
	bkey_cost_center,
	cost_center_code,
	cost_center_description,
	valid_from,
	valid_to,
	is_current
FROM source_cost_center