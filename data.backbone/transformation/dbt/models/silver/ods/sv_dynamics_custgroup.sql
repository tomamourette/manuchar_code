WITH source_dynamics_custgroup AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'CustGroup') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_custgroup
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

