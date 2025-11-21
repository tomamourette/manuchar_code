WITH source_mona_td055c2 AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY ConsolidatedAmountDimID, ConsoID ORDER BY ODSIngestionDate DESC) AS rn
    FROM {{ source('mona', 'td055c2') }}
    WHERE ODSActive = 1
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_td055c2
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated