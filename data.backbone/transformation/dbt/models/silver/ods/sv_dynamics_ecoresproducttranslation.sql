WITH source_dynamics_ecoresproducttranslation AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'EcoResProductTranslation') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_ecoresproducttranslation
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

