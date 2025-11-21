WITH source_dynamics_unitofmeasure AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'UnitOfMeasure') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_unitofmeasure
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

