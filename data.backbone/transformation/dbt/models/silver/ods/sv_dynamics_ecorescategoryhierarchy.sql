WITH source_dynamics_ecorescategoryhierarchy AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'EcoResCategoryHierarchy') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_ecorescategoryhierarchy
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

