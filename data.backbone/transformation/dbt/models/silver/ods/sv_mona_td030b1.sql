WITH source_mona_td030b1 AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY LocalReportedBundleID, ConsoID ORDER BY ODSIngestionDate DESC) AS rn
    FROM {{ source('mona', 'td030b1') }}
    WHERE ODSActive = 1
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_td030b1
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated