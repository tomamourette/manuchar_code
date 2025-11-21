WITH source_dynamics_vendortable AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'VendTable') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_vendortable
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

