WITH source_dynamics_custinvoicetrans AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY recid ORDER BY SinkModifiedOn DESC) AS rn
    FROM {{ source('dynamics', 'CustInvoiceTrans') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dynamics_custinvoicetrans
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated

