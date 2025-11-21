WITH source_dynamics_custtransopen AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'CustTransOpen') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_custtransopen
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

