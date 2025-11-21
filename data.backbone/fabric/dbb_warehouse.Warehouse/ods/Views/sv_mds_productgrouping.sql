-- Auto Generated (Do not modify) CBF4D670792535AF892B456AD4EF9E73860F063F3460EC12E0C0EAA58B87F67C
create view "ods"."sv_mds_productgrouping" as WITH source_mds_productgrouping AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."MDS__mdm_ProductGrouping"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_productgrouping
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;