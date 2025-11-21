-- Auto Generated (Do not modify) 23D79C9C1A09958E8503A046E46AD3F1920721ADC88F595956C211C70B4BC292
create view "ods"."sv_mds_productgroupingmapping" as WITH source_mds_productgroupingmapping AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."MDS__mdm_ProductGroupingMapping"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_productgroupingmapping
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;