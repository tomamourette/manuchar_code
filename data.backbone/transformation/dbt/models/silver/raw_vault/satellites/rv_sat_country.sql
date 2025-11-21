WITH country AS (
    SELECT
        mds.bkey_country_source,
        mds.country_name,
        mds.country_iso_code,
        mds.country_sort,
        mds.country_region_level_1,
        mds.country_region_level_1_sort,
        mds.country_region_level_2,
        mds.country_region_level_2_sort,
        CAST(mds.country_continent AS VARCHAR) AS country_continent,
        mds.valid_from,
        mds.valid_to,
        mds.is_current
    FROM {{ ref('country_mds') }} mds
    UNION ALL
    SELECT
        mona.bkey_country_source,
        mona.country_name,
        CAST(mona.country_iso_code AS VARCHAR) AS country_iso_code,
        CAST(mona.country_sort AS VARCHAR) AS country_sort,
        mona.country_region_level_1,
        mona.country_region_level_1_sort,
        mona.country_region_level_2,
        mona.country_region_level_2_sort,
        mona.country_continent,
        mona.valid_from,
        mona.valid_to,
        mona.is_current
    FROM {{ ref('country_mona') }} mona
)

SELECT 
   *
FROM country