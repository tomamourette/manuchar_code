WITH source_dynamics_inventtrans AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'InventTrans') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_inventtrans
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated


