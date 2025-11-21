WITH source_dwh_dim_customer AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY KDP_SK ORDER BY ingestion_timestamp DESC) AS rn
    FROM {{ source('dwh', 'dim_customer') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dwh_dim_customer
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated