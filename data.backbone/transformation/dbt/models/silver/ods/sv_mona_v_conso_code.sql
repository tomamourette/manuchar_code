WITH source_mona_v_conso_code AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY ConsoID ORDER BY ODSIngestionDate DESC) AS rn
    FROM {{ source('mona', 'v_conso_code') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_v_conso_code
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated