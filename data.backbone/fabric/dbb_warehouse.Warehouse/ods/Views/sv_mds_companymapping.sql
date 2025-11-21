-- Auto Generated (Do not modify) 945D444DE7150757400B2900C58DCDEAF1161CAE2CFADBA3CEDB28BA5BE5104E
create view "ods"."sv_mds_companymapping" as WITH source_mds_companymapping AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."MDS__mdm_CompanyMapping"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_companymapping
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;