WITH source_industry_mds AS (
    SELECT 
        bkey_industry_source,
        bkey_industry,
        bkey_source,
        valid_from AS ldts,
        CAST('MDS' AS VARCHAR(25)) AS record_source
    FROM {{ ref('industry_mds') }}
), 

source_industry_mona AS (
    SELECT 
        bkey_industry_source,
        bkey_industry,
        bkey_source,
        valid_from AS ldts,
        CAST('Mona' AS VARCHAR(25)) AS record_source
    FROM {{ ref('industry_mona') }}
), 

sources_combined AS (
    SELECT 
        bkey_industry_source,
        bkey_industry,
        bkey_source,
        ldts,
        record_source
    FROM source_industry_mds
    UNION
    SELECT 
        bkey_industry_source,
        bkey_industry,
        bkey_source,
        ldts,
        record_source
    FROM source_industry_mona
), 

sources_deduplicated AS (
    SELECT 
        bkey_industry_source,
        bkey_industry,
        bkey_source,
        ldts,
        record_source,
        ROW_NUMBER() OVER (PARTITION BY bkey_industry_source ORDER BY ldts ASC) AS row_number
    FROM sources_combined
)

SELECT 
    bkey_industry_source,
    bkey_industry,
    bkey_source,
    ldts,
    record_source
FROM sources_deduplicated
WHERE row_number = 1