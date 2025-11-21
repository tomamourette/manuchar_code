WITH source_dynamics_lgslogisticfiletable AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'LgsLogisticFileTable') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_lgslogisticfiletable
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

