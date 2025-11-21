WITH source_site_boomi AS (
    SELECT 
        bkey_site_source,
        bkey_site,
        bkey_source,
        valid_from AS ldts,
        CAST('OSS_GENERICDATA' AS VARCHAR(25)) AS record_source
    FROM {{ ref('site_oil_genericdata') }}
),

sources_combined AS (
    SELECT 
        bkey_site_source,
        bkey_site,
        bkey_source,
        ldts,
        record_source
    FROM source_site_boomi
), 

sources_deduplicated AS (
    SELECT 
        bkey_site_source,
        bkey_site,
        bkey_source,
        ldts,
        record_source,
        ROW_NUMBER() OVER (PARTITION BY bkey_site_source ORDER BY ldts ASC) AS row_number
    FROM sources_combined
)

SELECT
    bkey_site_source,
    bkey_site,
    bkey_source,
    ldts,
    record_source
FROM sources_deduplicated
WHERE row_number = 1