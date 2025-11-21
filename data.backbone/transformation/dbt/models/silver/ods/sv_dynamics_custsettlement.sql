WITH source_dynamics_custsettlement AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'CustSettlement') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_custsettlement
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

