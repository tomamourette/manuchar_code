WITH source_dynamics_mainaccount AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'MainAccount') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_mainaccount
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

