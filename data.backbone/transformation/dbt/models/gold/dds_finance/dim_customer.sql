WITH source_customer AS (
	SELECT
		-- Keys
		CAST(ROW_NUMBER() OVER(ORDER BY cus.bkey_customer) AS BIGINT) AS tkey_customer,
		CAST(cus.bkey_customer AS VARCHAR(255)) AS bkey_customer,
        CAST(cus.bkey_customer_global AS VARCHAR(255)) AS bkey_customer_global,
		-- Attributes
        CAST(cus.bkey_customer AS VARCHAR(255)) AS customer_code,
        CAST(cus.bkey_customer_global AS VARCHAR(255)) AS customer_global_code,
        cus.customer_id,
        cus.customer_legal_number,
        cus.customer_name,
        cus.customer_company,
        cus.customer_country_code,
        cus.customer_address,
        cus.customer_city,
        cus.customer_zip_code,
        cus.customer_industry,
        ind.industry_name AS customer_industry_description,
        CASE WHEN cus.customer_affiliate = 1 THEN 'Yes' ELSE 'No' END AS customer_affiliate,
        cus.customer_group,
        cus.customer_group_description,
        cus.customer_multinational_legal_number,
        cus.customer_multinational_name,
        cus.customer_gkam,
        -- Country Data
        CAST(cou.country_name AS VARCHAR(255)) AS customer_country_name,
		CAST(CASE
				WHEN cou.country_sort = 'UNK' THEN NULL
				ELSE cou.country_sort
			END AS INT) AS customer_country_sort,
		CAST(cou.country_iso_code AS VARCHAR(255)) AS customer_iso_code,
		CAST(CASE 
				WHEN cou.country_region_level_2 = 'Brazil' THEN 'Brazil'
				WHEN cou.country_region_level_2 = 'South America' THEN 'South America'
				WHEN cou.country_region_level_2 IN ('Central America', 'Caribs', 'North America') THEN 'Other Americas & Caribs'
				WHEN cou.country_region_level_2 IN ('Europe', 'Middle East', 'Africa', 'Mediterranean', 'Middle East North Africa') THEN 'EMEA'
				WHEN cou.country_region_level_2 IN ('Asia', 'Central Asia') THEN 'Asia'
				ELSE 'Unmapped'
			END AS VARCHAR(255)) AS customer_region_level_1,
		CAST(CASE 
				WHEN cou.country_region_level_2 = 'Brazil' THEN 1
				WHEN cou.country_region_level_2 = 'South America' THEN 2
				WHEN cou.country_region_level_2 IN ('Central America', 'Caribs', 'North America') THEN 3
				WHEN cou.country_region_level_2 IN ('Europe', 'Middle East', 'Africa', 'Mediterranean', 'Middle East North Africa') THEN 4
				WHEN cou.country_region_level_2 IN ('Asia', 'Central Asia') THEN 5
				ELSE NULL
			END AS INT) AS customer_region_level_1_sort,
		CAST(cou.country_region_level_2 AS VARCHAR(255)) AS customer_region_level_2,
		CAST(cou.country_region_level_2_sort AS INT) AS customer_region_level_2_sort,
		-- History metadata
		CAST(cus.valid_from AS DATETIME2(6)) AS valid_from,
		CAST(cus.valid_to AS DATETIME2(6)) AS valid_to,
		CAST(cus.is_current AS BIT) AS is_current
	FROM {{ ref('bv_customer') }} AS cus
    LEFT JOIN {{ ref('bv_country')}} AS cou ON cus.customer_country_code = cou.country_iso_code AND cou.is_current = 1
    LEFT JOIN {{ ref('bv_industry')}} AS ind ON cus.customer_industry = ind.bkey_industry AND ind.is_current = 1
	-- WHERE cus.is_current = 1 -- add only the latest version
)

SELECT 
	tkey_customer,
	bkey_customer,
    bkey_customer_global,
    customer_code,
    customer_global_code,
    customer_id,
    customer_legal_number,
    customer_name,
    customer_company,
    customer_country_code,
    customer_address,
    customer_city,
    customer_zip_code,
    customer_industry,
    customer_industry_description,
    customer_affiliate,
    customer_group,
    customer_group_description,
    customer_multinational_legal_number,
    customer_multinational_name,
    customer_gkam,
    customer_country_name,
    customer_country_sort,
    customer_iso_code,
    customer_region_level_1,
    customer_region_level_1_sort,
    customer_region_level_2,
    customer_region_level_2_sort,
	valid_from,
	valid_to,
	is_current
FROM source_customer