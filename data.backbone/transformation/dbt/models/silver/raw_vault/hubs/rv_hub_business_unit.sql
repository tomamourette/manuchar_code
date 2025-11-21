WITH source_business_unit_mds AS (
    SELECT 
        bkey_business_unit_source,
        bkey_business_unit,
        bkey_source,
        valid_from AS ldts,
        CAST('MDS' AS VARCHAR(25)) AS record_source
    FROM {{ ref('business_unit_mds') }}
), 

sources_combined AS (
    SELECT 
        bkey_business_unit_source,
        bkey_business_unit,
        bkey_source,
        ldts,
        record_source
    FROM source_business_unit_mds
),

sources_deduplicated AS (
    SELECT
        bkey_business_unit_source,
        bkey_business_unit,
        bkey_source,
        ldts,
        record_source,
        ROW_NUMBER() OVER (PARTITION BY bkey_business_unit_source ORDER BY ldts ASC) AS row_number
    FROM sources_combined
)

SELECT
    bkey_business_unit_source,
    bkey_business_unit,
    bkey_source,
    ldts,
    record_source
FROM sources_deduplicated
WHERE row_number = 1