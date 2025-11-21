WITH source_payment_term AS (
	SELECT 
		-- Keys
		CAST(ROW_NUMBER() OVER(ORDER BY pt.bkey_payment_term) AS BIGINT) AS tkey_payment_term,
		CAST(pt.bkey_payment_term AS VARCHAR(255)) AS bkey_payment_term,
		--Attributes
		CAST(pt.payment_term_code AS VARCHAR(255)) AS payment_term_code,
        CAST(pt.payment_term_description AS VARCHAR(255)) AS payment_term_description,
        CAST(pt.payment_term_number_of_days AS VARCHAR(50)) AS number_of_days,
		-- History metadata
    	CAST(pt.valid_from AS DATETIME2(6)) AS valid_from,
      	CAST(pt.valid_to AS DATETIME2(6)) AS valid_to,
    	CAST(pt.is_current AS BIT) AS is_current
	FROM {{ ref('bv_payment_term') }} pt
	WHERE pt.is_current = 1 -- add only the latest version
)

SELECT
	tkey_payment_term,
	bkey_payment_term,
    payment_term_code,
    payment_term_description,
    number_of_days,
	valid_from,
	valid_to,
	is_current
FROM source_payment_term