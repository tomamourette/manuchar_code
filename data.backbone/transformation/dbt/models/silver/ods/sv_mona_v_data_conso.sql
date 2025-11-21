WITH source_mona_v_data_conso AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY ConsolidatedAmountID, ConsoID ORDER BY ODSIngestionDate DESC) AS rn
    FROM {{ source('mona', 'v_data_conso') }}
    WHERE ODSActive = 1
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_v_data_conso
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated