WITH source_dynamics_vendinvoicejour AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'VendInvoiceJour') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_vendinvoicejour
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

