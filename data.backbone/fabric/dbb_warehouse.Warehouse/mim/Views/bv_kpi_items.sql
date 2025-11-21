-- Auto Generated (Do not modify) BE025EADB19CBF5643AFB58396F7B068C5B42A66F50555426DAB5BAB821EEBE9
create view "mim"."bv_kpi_items" as WITH kpi_items AS (
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
    FROM  "dbb_warehouse"."mim"."rv_sat_kpi_items" sat
)

SELECT
    *
FROM kpi_items;