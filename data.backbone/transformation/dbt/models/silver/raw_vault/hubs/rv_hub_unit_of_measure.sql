WITH source_unit_of_measure_mds AS (
    SELECT 
        bkey_unit_of_measure_source,
        bkey_unit_of_measure,
        bkey_source,
        valid_from ldts,
        CAST('MDS' AS VARCHAR(25)) AS record_source
    FROM {{ ref('unit_of_measure_mds') }}
), 

source_unit_of_measure_dynamics AS (
    SELECT 
        bkey_unit_of_measure_source,
        bkey_unit_of_measure,
        bkey_source,
        valid_from ldts,
        CAST('DYNAMICS' AS VARCHAR(25)) AS record_source
    FROM {{ ref('unit_of_measure_dynamics') }}
),

sources_combined AS (
    SELECT
        bkey_unit_of_measure_source,
        bkey_unit_of_measure,
        bkey_source,
        ldts,
        record_source
    FROM source_unit_of_measure_mds
    UNION
    SELECT
        bkey_unit_of_measure_source,
        bkey_unit_of_measure,
        bkey_source,
        ldts,
        record_source
    FROM source_unit_of_measure_dynamics
), 

sources_deduplicated AS (
    SELECT
        bkey_unit_of_measure_source,
        bkey_unit_of_measure,
        bkey_source,
        ldts,
        record_source,
        ROW_NUMBER() OVER (PARTITION BY bkey_unit_of_measure_source ORDER BY ldts ASC) AS row_number
    FROM sources_combined
)

SELECT 
    bkey_unit_of_measure_source,
    bkey_unit_of_measure,
    bkey_source,
    ldts,
    record_source
FROM sources_deduplicated
WHERE row_number = 1