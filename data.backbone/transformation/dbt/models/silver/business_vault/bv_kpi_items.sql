WITH kpi_items AS (
    SELECT
        sat.tkey_kpi,
        sat.bkey_kpi,
        sat.bkey_source,
        sat.kpi_name,
        sat.kpi_sort_number,
        sat.kpi_type,
        sat.valid_from,
        sat.valid_to,
        sat.is_current
    FROM  {{ ref('rv_sat_kpi_items')}} sat
)

SELECT
    *
FROM kpi_items