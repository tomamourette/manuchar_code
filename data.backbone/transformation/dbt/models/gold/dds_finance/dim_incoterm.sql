WITH source_incoterm AS (
	SELECT 
		-- Keys
		CAST(ROW_NUMBER() OVER(ORDER BY it.bkey_incoterm) AS BIGINT) AS tkey_incoterm,
		CAST(it.bkey_incoterm AS VARCHAR(255)) AS bkey_incoterm,
		--Attributes
		CAST(it.incoterm_code AS VARCHAR(255)) AS incoterm_code,
        CAST(it.incoterm_description AS VARCHAR(255)) AS incoterm_description,
		-- History metadata
    	CAST(it.valid_from AS DATETIME2(6)) AS valid_from,
      	CAST(it.valid_to AS DATETIME2(6)) AS valid_to,
    	CAST(it.is_current AS BIT) AS is_current
	FROM {{ ref('bv_incoterm') }} it
	WHERE it.is_current = 1 -- add only the latest version
)

SELECT
	tkey_incoterm,
	bkey_incoterm,
    incoterm_code,
    incoterm_description,
	valid_from,
	valid_to,
	is_current
FROM source_incoterm