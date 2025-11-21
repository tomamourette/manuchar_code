WITH kpi_items AS (
    SELECT
        kpi.TKEY_KPI AS tkey_kpi,
        kpi.KPI_NAME AS bkey_kpi,
        kpi.KPI_NAME + '_oil_monaconso' AS bkey_kpi_source,
        'oil_monaconso' AS bkey_source,
        kpi.KPI_NAME AS kpi_name,
        kpi.KPI_SORT_NR AS kpi_sort_number,
        kpi.KPI_TYPE AS kpi_type,
        CAST('1900-01-01 00:00:00.000000' AS DATETIME2(6)) AS valid_from,
        CAST('2999-12-31 23:59:59.999999' AS DATETIME2(6)) AS valid_to,
        CASE 
            WHEN '2999-12-31 23:59:59.999999' = '2999-12-31 23:59:59.999999' THEN 1 
            ELSE 0 
        END AS is_current
    FROM {{ ref('sv_oil_monaconso_ref_kpi_items')}} kpi
)

SELECT 
    *
FROM kpi_items