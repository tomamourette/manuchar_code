-- Auto Generated (Do not modify) 290B6DD83B5E06239EEF76DDC0B8290D2B07D2D9444E9A939B3F5F6C7E04B632
create view "ods"."sv_mds_companyhistory" as WITH source_mds_companyhistory AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."MDS__mdm_CompanyHistory"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_companyhistory
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;