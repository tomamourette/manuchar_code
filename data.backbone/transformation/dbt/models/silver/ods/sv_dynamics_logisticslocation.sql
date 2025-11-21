WITH source_dynamics_logisticslocation AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'LogisticsLocation') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_logisticslocation
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

