WITH source_dynamics_inventlocation AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'InventLocations') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_inventlocation
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

