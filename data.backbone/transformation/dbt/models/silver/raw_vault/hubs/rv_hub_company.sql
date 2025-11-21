WITH source_company_mds AS (
    SELECT 
        bkey_company_source,
        bkey_company,
        bkey_source,
        valid_from AS ldts,
        CAST('MDS' AS VARCHAR(25)) AS record_source
    FROM {{ ref('company_mds') }}
), 

source_company_mona AS (
    SELECT 
        bkey_company_source,
        bkey_company,
        bkey_source,
        valid_from AS ldts,
        CAST('MDS' AS VARCHAR(25)) AS record_source
    FROM {{ ref('company_mona') }}
), 

source_company_dynamics AS (
    SELECT 
        bkey_company_source,
        bkey_company,
        bkey_source,
        valid_from AS ldts,
        CAST('MDS' AS VARCHAR(25)) AS record_source
    FROM {{ ref('company_dynamics') }}
), 

sources_combined AS (
    SELECT 
        bkey_company_source,
        bkey_company,
        bkey_source,
        ldts,
        record_source
    FROM source_company_mds
    UNION
    SELECT 
        bkey_company_source,
        bkey_company,
        bkey_source,
        ldts,
        record_source
    FROM source_company_mona
    UNION
    SELECT 
        bkey_company_source,
        bkey_company,
        bkey_source,
        ldts,
        record_source
    FROM source_company_dynamics
), 

sources_deduplicated AS (
    SELECT 
        bkey_company_source,
        bkey_company,
        bkey_source,
        ldts,
        record_source,
        ROW_NUMBER() OVER (PARTITION BY bkey_company_source ORDER BY ldts ASC) AS row_number
    FROM sources_combined
)

SELECT 
    bkey_company_source,
    bkey_company,
    bkey_source,
    ldts,
    record_source
FROM sources_deduplicated
WHERE row_number = 1