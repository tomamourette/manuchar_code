WITH source_mds_accounthierarchy AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code, LastChgDateTime ORDER BY LastChgDateTime DESC) AS rn
    FROM {{ source('mds', 'AccountHierarchy') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_accounthierarchy
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated