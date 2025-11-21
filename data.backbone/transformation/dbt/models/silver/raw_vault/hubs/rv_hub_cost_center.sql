WITH source_cost_center_dbb_lakehouse AS (
    SELECT 
        bkey_cost_center_source,
        bkey_cost_center,
        bkey_source,
        valid_from AS ldts,
        CAST('dbb_lakehouse' AS VARCHAR(25)) AS record_source
    FROM {{ ref('cost_center_dbb_lakehouse') }}
), 

sources_combined AS (
    SELECT 
        bkey_cost_center_source,
        bkey_cost_center,
        bkey_source,
        ldts,
        record_source
    FROM source_cost_center_dbb_lakehouse
), 

sources_deduplicated AS (
    SELECT 
        bkey_cost_center_source,
        bkey_cost_center,
        bkey_source,
        ldts,
        record_source,
        ROW_NUMBER() OVER (PARTITION BY bkey_cost_center_source ORDER BY ldts ASC) AS row_number
    FROM sources_combined
)

SELECT 
    bkey_cost_center_source,
    bkey_cost_center,
    bkey_source,
    ldts,
    record_source
FROM sources_deduplicated
WHERE row_number = 1