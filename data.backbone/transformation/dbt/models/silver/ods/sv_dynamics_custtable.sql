WITH source_dynamics_custtable AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'CustTable') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_custtable
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

