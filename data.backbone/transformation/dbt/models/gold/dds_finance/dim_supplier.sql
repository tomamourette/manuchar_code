WITH source_supplier AS (
	SELECT 
		-- Keys
		CAST(ROW_NUMBER() OVER(ORDER BY sup.bkey_supplier) AS BIGINT) AS tkey_supplier,
		CAST(sup.bkey_supplier AS VARCHAR(255)) AS bkey_supplier,
		CAST(sup.bkey_supplier_global AS VARCHAR(255)) AS bkey_supplier_global,
		--Attributes
		CAST(sup.bkey_supplier AS VARCHAR(255)) AS supplier_code,
		CAST(sup.bkey_supplier_global AS VARCHAR(255)) AS supplier_global_code,
		CAST(sup.supplier_group AS VARCHAR(255)) AS supplier_group,
		CAST(sup.supplier_group_description AS VARCHAR(255)) AS supplier_group_description,
		CAST(sup.supplier_name AS VARCHAR(255)) AS supplier_name,
		CAST(sup.supplier_id AS VARCHAR(255)) AS supplier_id,
		CAST(sup.supplier_company AS VARCHAR(255)) AS supplier_company,
        CAST(sup.supplier_address AS VARCHAR(255)) AS supplier_address,
        CAST(sup.supplier_city AS VARCHAR(255)) AS supplier_city,
        CAST(sup.supplier_zip_code AS VARCHAR(255)) AS supplier_zipcode,
		CASE WHEN sup.supplier_affiliate = 1 THEN 'Yes' ELSE 'No' END AS supplier_affiliate,
		CAST(sup.supplier_country_code AS VARCHAR(3)) AS supplier_country_code,
		CAST(sup.supplier_legal_number AS VARCHAR(255)) AS supplier_legal_number,
		-- Country Data
		CAST(cou.country_name AS VARCHAR(255)) AS supplier_country_name,
		CAST(CASE
				WHEN cou.country_sort = 'UNK' THEN NULL
				ELSE cou.country_sort
			END AS INT) AS supplier_country_sort,
		CAST(cou.country_iso_code AS VARCHAR(255)) AS supplier_iso_code,
		CAST(CASE 
				WHEN cou.country_region_level_2 = 'Brazil' THEN 'Brazil'
				WHEN cou.country_region_level_2 = 'South America' THEN 'South America'
				WHEN cou.country_region_level_2 IN ('Central America', 'Caribs', 'North America') THEN 'Other Americas & Caribs'
				WHEN cou.country_region_level_2 IN ('Europe', 'Middle East', 'Africa', 'Mediterranean', 'Middle East North Africa') THEN 'EMEA'
				WHEN cou.country_region_level_2 IN ('Asia', 'Central Asia') THEN 'Asia'
				ELSE 'Unmapped'
			END AS VARCHAR(255)) AS supplier_region_level_1,
		CAST(CASE 
				WHEN cou.country_region_level_2 = 'Brazil' THEN 1
				WHEN cou.country_region_level_2 = 'South America' THEN 2
				WHEN cou.country_region_level_2 IN ('Central America', 'Caribs', 'North America') THEN 3
				WHEN cou.country_region_level_2 IN ('Europe', 'Middle East', 'Africa', 'Mediterranean', 'Middle East North Africa') THEN 4
				WHEN cou.country_region_level_2 IN ('Asia', 'Central Asia') THEN 5
				ELSE NULL
			END AS INT) AS supplier_region_level_1_sort,
		CAST(cou.country_region_level_2 AS VARCHAR(255)) AS supplier_region_level_2,
		CAST(cou.country_region_level_2_sort AS INT) AS supplier_region_level_2_sort,
		-- History metadata
    	CAST(sup.valid_from AS DATETIME2(6)) AS valid_from,
      	CAST(sup.valid_to AS DATETIME2(6)) AS valid_to,
    	CAST(sup.is_current AS BIT) AS is_current
	FROM {{ ref('bv_supplier') }} sup
	LEFT JOIN {{ ref('bv_country') }} cou ON sup.supplier_country_code = cou.country_iso_code AND cou.is_current = 1
	-- WHERE cpy.is_current = 1 -- add only the latest version
)

SELECT
	tkey_supplier,
	bkey_supplier,
	bkey_supplier_global,
	supplier_code,
	supplier_global_code,
	supplier_group,
	supplier_group_description,
	supplier_name,
	supplier_id,
    supplier_address,
    supplier_city,
    supplier_zipcode,
	supplier_affiliate,
	supplier_country_code,
	supplier_legal_number,
	supplier_country_name,
	supplier_country_sort,
	supplier_iso_code,
	supplier_region_level_1,
	supplier_region_level_1_sort,
	supplier_region_level_2,
	supplier_region_level_2_sort,
	valid_from,
	valid_to,
	is_current
FROM source_supplier