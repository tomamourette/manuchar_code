WITH source_dynamics_inventsum AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'InventSums') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_inventsum
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

