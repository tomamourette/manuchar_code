WITH source_mona_ts014m1 AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY AddInfoCompanyID, ConsoID ORDER BY ConsoID, ODSIngestionDate DESC) AS rn
    FROM {{ source('mona', 'ts014m1') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_ts014m1
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated