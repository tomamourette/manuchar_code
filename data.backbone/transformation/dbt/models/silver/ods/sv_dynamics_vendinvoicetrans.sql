WITH source_dynamics_vendinvoicetrans AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'VendInvoiceTrans') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_vendinvoicetrans
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

