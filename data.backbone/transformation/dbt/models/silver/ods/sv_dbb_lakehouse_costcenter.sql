WITH source_dbb_lakehouse_costcenter AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM {{ source('dbb_lakehouse', 'Costcenter') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dbb_lakehouse_costcenter
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated