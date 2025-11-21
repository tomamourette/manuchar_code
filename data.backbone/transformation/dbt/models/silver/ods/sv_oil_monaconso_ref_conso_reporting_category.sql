WITH source_oil_mona_conso_ref_conso_reporting_category AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY category_mona, version_mona, valid_to ORDER BY valid_to DESC) AS rn
    FROM {{ source('oil_monaconso', 'RefConsoReportingCategory') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_oil_mona_conso_ref_conso_reporting_category
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated