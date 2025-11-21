WITH source_dynamics_currency AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'Currency') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_currency
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

