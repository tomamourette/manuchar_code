WITH source_dynamics_salestable AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'SalesTables') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_salestable
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

