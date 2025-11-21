WITH source_mds_accountheaders AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code, LastChgDateTime ORDER BY LastChgDateTime DESC) AS rn
    FROM {{ source('mds', 'AccountHeader') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_accountheaders
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated