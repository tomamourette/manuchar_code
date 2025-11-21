WITH source_mds_industrytypesexceptions AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM {{ source('mds', 'IndustryTypesExceptions') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_industrytypesexceptions
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated