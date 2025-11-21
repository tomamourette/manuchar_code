WITH source_country AS (
	SELECT
		-- Keys
		CAST(ROW_NUMBER() OVER(ORDER BY cou.bkey_country) AS BIGINT) AS tkey_country,
		CAST(cou.bkey_country AS VARCHAR(255)) AS bkey_country,
		-- Attributes
		CAST(cou.bkey_country AS VARCHAR(255)) AS country_code,
		CAST(cou.country_name AS VARCHAR(255)) AS country_name,
		CAST(CASE
				WHEN cou.country_sort = 'UNK' THEN NULL
				ELSE cou.country_sort
			END AS INT) AS country_sort,
		CAST(cou.country_iso_code AS VARCHAR(255)) AS country_iso_code,
		CAST(CASE 
				WHEN cou.country_region_level_2 = 'Brazil' THEN 'Brazil'
				WHEN cou.country_region_level_2 = 'South America' THEN 'South America'
				WHEN cou.country_region_level_2 IN ('Central America', 'Caribs', 'North America') THEN 'Other Americas & Caribs'
				WHEN cou.country_region_level_2 IN ('Europe', 'Middle East', 'Africa', 'Mediterranean', 'Middle East North Africa') THEN 'EMEA'
				WHEN cou.country_region_level_2 IN ('Asia', 'Central Asia') THEN 'Asia'
				ELSE 'Unmapped'
			END AS VARCHAR(255)) AS region_level_1,
		CAST(CASE 
				WHEN cou.country_region_level_2 = 'Brazil' THEN 1
				WHEN cou.country_region_level_2 = 'South America' THEN 2
				WHEN cou.country_region_level_2 IN ('Central America', 'Caribs', 'North America') THEN 3
				WHEN cou.country_region_level_2 IN ('Europe', 'Middle East', 'Africa', 'Mediterranean', 'Middle East North Africa') THEN 4
				WHEN cou.country_region_level_2 IN ('Asia', 'Central Asia') THEN 5
				ELSE NULL
			END AS INT) AS region_level_1_sort,
		CAST(cou.country_region_level_2 AS VARCHAR(255)) AS region_level_2,
		CAST(cou.country_region_level_2_sort AS INT) AS region_level_2_sort,
		-- History metadata
		CAST(cou.valid_from AS DATETIME2(6)) AS valid_from,
		CAST(cou.valid_to AS DATETIME2(6)) AS valid_to,
		CAST(cou.is_current AS BIT) AS is_current
	FROM {{ ref('bv_country') }} AS cou
	WHERE cou.is_current = 1 -- add only the latest version
)

SELECT
	tkey_country,
	bkey_country,
	country_code,
	country_name,
	country_sort,
	country_iso_code,
	region_level_1,
	region_level_1_sort,
	region_level_2,
	region_level_2_sort,
	valid_from,
	valid_to,
	is_current 
FROM source_country