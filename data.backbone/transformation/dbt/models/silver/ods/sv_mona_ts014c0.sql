WITH source_mona_ts014c0 AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY CompanyID, ConsoID ORDER BY ConsoID, ODSIngestionDate DESC) AS rn
    FROM {{ source('mona', 'ts014c0') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_ts014c0
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated