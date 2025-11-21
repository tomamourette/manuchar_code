WITH source_mds_agegroups AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM {{ source('mds', 'AgeGroup') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_agegroups
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated