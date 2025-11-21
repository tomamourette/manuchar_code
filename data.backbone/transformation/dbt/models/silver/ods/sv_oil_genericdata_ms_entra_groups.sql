WITH source_oil_generic_ms_entra_groups AS (
    SELECT
        *
    FROM {{ source('oil_genericdata', 'MS_Entra_Groups') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_oil_generic_ms_entra_groups
)
 
SELECT
    *
FROM deduplicated