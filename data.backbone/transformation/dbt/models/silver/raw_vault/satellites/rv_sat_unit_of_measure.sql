WITH unit_of_measure AS (
    SELECT
        bkey_unit_of_measure_source,
        unit_of_measure_name,
        unit_of_measure_description,
        unit_of_measure_conversion_to_mt,
        valid_from,
        valid_to,
        is_current
    FROM {{ ref('unit_of_measure_mds') }}

    UNION ALL

    SELECT
        bkey_unit_of_measure_source,
        unit_of_measure_name,
        unit_of_measure_description,
        unit_of_measure_conversion_to_mt,
        valid_from,
        valid_to,
        is_current
    FROM {{ ref('unit_of_measure_dynamics') }}
)

SELECT 
    *
FROM unit_of_measure