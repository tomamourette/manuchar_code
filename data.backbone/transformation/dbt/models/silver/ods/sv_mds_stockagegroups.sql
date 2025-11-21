WITH source_mds_stockagegroups AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM {{ source('mds', 'StockAgeGroups') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_stockagegroups
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated