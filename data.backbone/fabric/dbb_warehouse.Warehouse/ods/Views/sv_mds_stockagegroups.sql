-- Auto Generated (Do not modify) B7BE6E37767B1E2039501849384E34BA2825FAB1AC322949E06D826BC3B84E6D
create view "ods"."sv_mds_stockagegroups" as WITH source_mds_stockagegroups AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."MDS__mdm_StockAgeGroups"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_stockagegroups
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;