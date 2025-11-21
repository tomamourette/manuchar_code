WITH source_dynamics_dimensionattributevaluecombination AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'DimensionAttributeValueCombination') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_dimensionattributevaluecombination
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

