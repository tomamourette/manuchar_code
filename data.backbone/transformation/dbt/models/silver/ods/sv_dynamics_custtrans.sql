WITH source_dynamics_custtrans AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'CustTran') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_custtrans
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

