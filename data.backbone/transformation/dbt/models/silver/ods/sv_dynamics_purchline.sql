WITH source_dynamics_purchline AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'PurchLine') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_purchline
    WHERE rn = 1
)

SELECT
    *
FROM deduplicated

