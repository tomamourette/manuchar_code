WITH source_oil_genericdata_site AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY SiteCode ORDER BY ModifiedDateTime DESC) AS rn
    FROM {{ source('oil_genericdata', 'ref_sites') }}
),

deduplicated AS (
    SELECT
        *
    FROM source_oil_genericdata_site
    WHERE rn = 1
)

SELECT
    *
FROM deduplicated