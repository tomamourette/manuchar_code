WITH source_oil_monaconso_ref_kpi_items AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY TKEY_KPI ORDER BY TKEY_KPI DESC) AS rn
    FROM {{ source('oil_monaconso', 'KpiItems') }}
),
 
deduplicated AS (
    SELECT
        *
    FROM source_oil_monaconso_ref_kpi_items
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated