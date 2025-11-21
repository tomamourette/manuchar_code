WITH source_dynamics_vendorgroup AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'VendGroup') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_vendorgroup
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

