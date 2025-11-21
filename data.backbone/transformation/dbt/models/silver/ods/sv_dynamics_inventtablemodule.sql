WITH source_dynamics_inventtablemodule AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'InventTableModule') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_inventtablemodule
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated


