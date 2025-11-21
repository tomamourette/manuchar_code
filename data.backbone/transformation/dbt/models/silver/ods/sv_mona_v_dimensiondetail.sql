WITH source_mona_v_dimensiondetail AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY DimensionDetailID, ConsoID ORDER BY ConsoID, ODSIngestionDate DESC) AS rn
    FROM {{ source('mona', 'v_dimensiondetail') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_v_dimensiondetail
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated