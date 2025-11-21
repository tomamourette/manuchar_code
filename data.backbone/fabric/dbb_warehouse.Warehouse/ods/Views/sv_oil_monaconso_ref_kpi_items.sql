-- Auto Generated (Do not modify) 2CC2B91C94AD1452E603DBD6E8AFB8170F8A2C4D14795A448579597A6FAC6613
create view "ods"."sv_oil_monaconso_ref_kpi_items" as WITH source_oil_monaconso_ref_kpi_items AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY TKEY_KPI ORDER BY TKEY_KPI DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."OIL_MonaConso__REF_KPI_ITEMS"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_oil_monaconso_ref_kpi_items
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;