WITH source_business_unit AS (
    SELECT
        -- Keys
        CAST(ROW_NUMBER() OVER(ORDER BY bu.bkey_business_unit) AS BIGINT) AS tkey_business_unit,
	    CAST(bu.bkey_business_unit AS VARCHAR(255)) AS bkey_business_unit,
	    -- Attributes
	    CAST(bu.bkey_business_unit AS VARCHAR(255)) AS business_unit_code,
      	CAST(bu.business_unit_name AS VARCHAR(255)) AS business_unit_description,
      	-- History metadata
    	CAST(bu.valid_from AS DATETIME2(6)) AS valid_from,
      	CAST(bu.valid_to AS DATETIME2(6)) AS valid_to,
    	CAST(bu.is_current AS BIT) AS is_current
    FROM {{ ref('bv_business_unit') }} bu
    WHERE bu.is_current = 1 -- add only the latest version
)

SELECT 
    tkey_business_unit,
    bkey_business_unit,
    business_unit_code,
    business_unit_description,
    valid_from,
    valid_to,
    is_current
FROM source_business_unit