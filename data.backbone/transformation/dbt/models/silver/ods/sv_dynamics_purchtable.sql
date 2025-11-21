WITH source_dynamics_purchtable AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'PurchTable') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_purchtable
    WHERE rn = 1
)

SELECT
    *
FROM deduplicated

