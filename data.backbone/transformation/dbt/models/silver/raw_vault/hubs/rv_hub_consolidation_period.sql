WITH source_consolidation_period_mona AS (
    SELECT 
        bkey_consolidation_period_source,
        bkey_consolidation_period,
        bkey_source,
        valid_from AS ldts,
        CAST('Mona' AS VARCHAR(25)) AS record_source
    FROM {{ ref('consolidation_period_mona') }}
), 

sources_combined AS (
    SELECT 
        bkey_consolidation_period_source,
        bkey_consolidation_period,
        bkey_source,
        ldts,
        record_source
    FROM source_consolidation_period_mona
), 

sources_deduplicated AS (
    SELECT
        bkey_consolidation_period_source,
        bkey_consolidation_period,
        bkey_source,
        ldts,
        record_source,
        ROW_NUMBER() OVER (PARTITION BY bkey_consolidation_period_source ORDER BY ldts ASC) AS row_number
    FROM sources_combined
)

SELECT 
    bkey_consolidation_period_source,
    bkey_consolidation_period,
    bkey_source,
    ldts,
    record_source
FROM sources_deduplicated
WHERE row_number = 1