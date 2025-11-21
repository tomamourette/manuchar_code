WITH source_dynamics_custinvoicejour AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'CustInvoiceJour') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_custinvoicejour
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

