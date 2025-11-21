WITH source_dynamics_ecoresproduct AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'EcoResProduct') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_ecoresproduct
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

