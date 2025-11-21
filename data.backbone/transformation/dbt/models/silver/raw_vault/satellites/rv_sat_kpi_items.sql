WITH kpi_items AS (
    SELECT
        kpi.bkey_kpi_source,
        kpi.tkey_kpi,
        kpi.bkey_kpi,
        kpi.bkey_source,
        kpi.kpi_name,
        kpi.kpi_sort_number,
        kpi.kpi_type,
        kpi.valid_from,
        kpi.valid_to,
        kpi.is_current
    FROM {{ ref('kpi_items_oil_monaconso') }} AS kpi
)

SELECT
    *
FROM kpi_items