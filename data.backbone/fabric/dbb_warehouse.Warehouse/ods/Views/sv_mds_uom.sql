-- Auto Generated (Do not modify) 97A35109B5D85D3FE51119BC4FF9D8BCBED8412D92C88FCDC5980CE3B20A1153
create view "ods"."sv_mds_uom" as WITH source_mds_uom AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."MDS__mdm_UOM"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_uom
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;