WITH source_mds_location AS (
    SELECT 
        bkey_location_source,
        bkey_location,
        bkey_source,
        CAST(valid_from AS DATETIME2(6)) AS ldts,
        CAST('MDS' AS VARCHAR(25)) AS record_source
    FROM {{ ref('location_mds') }}
), 

sources_combined AS (
    SELECT 
        bkey_location_source,
        bkey_location,
        bkey_source,
        ldts,
        record_source
    FROM source_mds_location
), 

sources_deduplicated AS (
    SELECT 
        bkey_location_source,
        bkey_location,
        bkey_source,
        ldts,
        record_source,
        ROW_NUMBER() OVER (PARTITION BY bkey_location_source ORDER BY ldts ASC) AS row_number
    FROM sources_combined
)

SELECT 
    bkey_location_source,
    bkey_location,
    bkey_source,
    ldts,
    record_source
FROM sources_deduplicated
WHERE row_number = 1