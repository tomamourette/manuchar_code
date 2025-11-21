-- Auto Generated (Do not modify) 3801BEFD2B50F3ED999232BB969875C26B2004CA5DEB416074AB35AC84682268
create view "ods"."sv_mds_productaffiliatemapping" as WITH source_mds_productaffiliatemapping AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."MDS__mdm_ProductAffiliateMapping"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_productaffiliatemapping
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;