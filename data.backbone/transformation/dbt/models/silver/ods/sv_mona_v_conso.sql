WITH source_mona_v_conso AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY ConsoID ORDER BY ODSIngestionDate DESC) AS rn
    FROM {{ source('mona', 'v_conso') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_v_conso
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated