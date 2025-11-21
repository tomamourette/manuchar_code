WITH source_dynamics_paymterm AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'PaymTerm') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_paymterm
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

