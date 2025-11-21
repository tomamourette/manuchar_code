WITH source_dynamics_ecorescategory AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'EcoResCategory') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_ecorescategory
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

