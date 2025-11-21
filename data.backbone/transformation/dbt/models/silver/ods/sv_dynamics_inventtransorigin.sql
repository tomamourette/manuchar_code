WITH source_dynamics_inventtransorigin AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'InventTransOrigin') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_inventtransorigin
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated


