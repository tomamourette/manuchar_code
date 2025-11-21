WITH source_dynamics_dimensionattributevalueset AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'DimensionAttributeValueSet') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_dimensionattributevalueset
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

