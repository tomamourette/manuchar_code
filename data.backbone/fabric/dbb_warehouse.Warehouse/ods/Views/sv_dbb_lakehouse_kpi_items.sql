-- Auto Generated (Do not modify) A8D231A0B02819D932E5419C42205C0315683F8BEC04E1D8E8F6AB4CDCC31092
create view "ods"."sv_dbb_lakehouse_kpi_items" as WITH source_dbb_lakehouse_kpi_items AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY TKEY_KPI ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."dbb_lakehouse__dbo_enum_kpi_items"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_dbb_lakehouse_kpi_items
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;