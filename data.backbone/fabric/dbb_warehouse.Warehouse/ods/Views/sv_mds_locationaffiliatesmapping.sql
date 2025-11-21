-- Auto Generated (Do not modify) B89ABD2316539E3CE82129AAFEA9E993B7F7A5C5CF7F6B839E1DE149CC267A83
create view "ods"."sv_mds_locationaffiliatesmapping" as WITH source_mds_locationaffiliatesmapping AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."MDS__mdm_LocationAffiliatesMapping"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_locationaffiliatesmapping
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;