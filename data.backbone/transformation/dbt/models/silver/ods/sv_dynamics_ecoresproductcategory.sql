WITH source_dynamics_ecoresproductcategory AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'EcoResProductCategory') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_ecoresproductcategory
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

