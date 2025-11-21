WITH source_vessel AS (
	SELECT 
		-- Keys
		CAST(ROW_NUMBER() OVER(ORDER BY sv.bkey_vessel) AS BIGINT) AS tkey_vessel,
		CAST(sv.bkey_vessel AS VARCHAR(255)) AS bkey_vessel,
		--Attributes
		CAST(sv.vessel_id AS VARCHAR(255)) AS vessel_id,
        CAST(sv.vessel_description AS VARCHAR(255)) AS vessel_description,
		-- History metadata
    	CAST(sv.valid_from AS DATETIME2(6)) AS valid_from,
      	CAST(sv.valid_to AS DATETIME2(6)) AS valid_to,
    	CAST(sv.is_current AS BIT) AS is_current
	FROM {{ ref('bv_vessel') }} sv
	WHERE sv.is_current = 1 -- add only the latest version
)

SELECT
	tkey_vessel,
	bkey_vessel,
    vessel_id,
    vessel_description,
	valid_from,
	valid_to,
	is_current
FROM source_vessel