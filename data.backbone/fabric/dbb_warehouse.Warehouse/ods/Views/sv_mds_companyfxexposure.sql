-- Auto Generated (Do not modify) 218A97D78A39B72A45E0E8B823CA924B867414AB8B8C6413099CC04778DD68E2
create view "ods"."sv_mds_companyfxexposure" as WITH source_mds_companyfxexposure AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."MDS__mdm_CompanyFXExposure"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_companyfxexposure
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;