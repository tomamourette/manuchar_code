WITH source_site_oil_genericdata_locations AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY LocationCode ORDER BY ModifiedDateTime DESC) AS rn
    FROM {{ source('oil_genericdata', 'ref_locations') }}
),

deduplicated AS (
    SELECT 
        *
    FROM source_site_oil_genericdata_locations
    WHERE rn = 1
)

SELECT 
    *
FROM deduplicated