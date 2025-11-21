WITH source_dynamics_incoterm AS (
    SELECT 
        bkey_incoterm_source,
        bkey_incoterm,
        bkey_source,
        CAST(pol.valid_from AS DATETIME2(6)) AS ldts,
        CAST('Dynamics 365' AS VARCHAR(25)) AS record_source
    FROM {{ ref('incoterm_dynamics') }} AS pol
    WHERE is_current = 1
), 

sources_combined AS (
    SELECT 
        bkey_incoterm_source,
        bkey_incoterm,
        bkey_source,
        ldts,
        record_source
    FROM source_dynamics_incoterm
), 

sources_deduplicated AS (
    SELECT 
        bkey_incoterm_source,
        bkey_incoterm,
        bkey_source,
        ldts,
        record_source,
        ROW_NUMBER() OVER (PARTITION BY bkey_incoterm_source ORDER BY ldts ASC) AS row_number
    FROM sources_combined
)

SELECT 
    bkey_incoterm_source,
    bkey_incoterm,
    bkey_source,
    ldts,
    record_source
FROM sources_deduplicated
WHERE row_number = 1