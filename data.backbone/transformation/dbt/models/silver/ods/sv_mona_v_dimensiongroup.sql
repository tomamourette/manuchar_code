WITH source_mona_v_dimensiongroup AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY DimensionGroupID, ConsoID ORDER BY ConsoID, ODSIngestionDate DESC) AS rn
    FROM {{ source('mona', 'v_dimensiongroup') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_v_dimensiongroup
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated