WITH source_age_group AS (
	SELECT 
		-- Keys
		CAST(ROW_NUMBER() OVER(ORDER BY ag.bkey_age_group) AS BIGINT) AS tkey_age_group,
		CAST(ag.bkey_age_group AS VARCHAR(255)) AS bkey_age_group,
		-- Attributes
		CAST(ag.bkey_age_group AS VARCHAR(255)) AS age_group_code,
		CAST(ag.age_group_name AS VARCHAR(255)) AS age_group_name,
        CAST(ag.age_group_id AS VARCHAR(255)) AS age_group_id,
        CAST(ag.age_group_min_days AS VARCHAR(255)) AS age_group_min_days,
        CAST(ag.age_group_max_days AS VARCHAR(255)) AS age_group_max_days,
        CAST(ag.age_group_sort AS VARCHAR(255)) AS age_group_sort,
		-- History metadata
		CAST(ag.valid_from AS DATETIME2(6)) AS valid_from,
	  	CAST(ag.valid_to AS DATETIME2(6)) AS valid_to,
		CAST(ag.is_current AS BIT) AS is_current
	FROM {{ ref('bv_age_group') }} AS ag
	WHERE ag.is_current = 1 -- add only the latest version
)

SELECT 
	tkey_age_group,
	bkey_age_group,
	age_group_code,
	age_group_name,
    age_group_id,
    age_group_min_days,
    age_group_max_days,
    age_group_sort,
	valid_from,
	valid_to,
	is_current
FROM source_age_group