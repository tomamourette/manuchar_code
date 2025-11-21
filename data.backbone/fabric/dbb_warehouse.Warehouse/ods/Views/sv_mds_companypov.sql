-- Auto Generated (Do not modify) F6D0011B6C1D24A9F807F88734DE61CC00920CED17742483C85C985B2CAE8A2F
create view "ods"."sv_mds_companypov" as WITH source_mds_companypov AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."MDS__mdm_MONA_CompanyPOV"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_companypov
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;