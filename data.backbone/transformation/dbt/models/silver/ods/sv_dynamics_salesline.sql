WITH source_dynamics_salesline AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'SalesLine') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_salesline
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

