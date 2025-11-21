WITH source_dynamics_itmvesseltable AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'ItmVesselTable') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_itmvesseltable
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

