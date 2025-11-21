WITH source_dynamics_lgslogisticfileline AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'LgsLogisticFileLine') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_lgslogisticfileline
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

