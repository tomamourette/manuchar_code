WITH source_kpi_items AS (
	SELECT 
		-- Keys
		kpi.tkey_kpi,
		kpi.bkey_kpi,
		-- Attributes
        kpi.kpi_name,
        kpi.kpi_sort_number,
		kpi.kpi_type,
		kpi.valid_from,
		kpi.valid_to,
		kpi.is_current

	FROM {{ ref('bv_kpi_items') }} kpi
)

SELECT
	tkey_kpi,
	bkey_kpi,
	kpi_name,
    kpi_sort_number,
	kpi_type,
	valid_from,
	valid_to,
	is_current
FROM source_kpi_items