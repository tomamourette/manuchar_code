-- Auto Generated (Do not modify) F8B2AD79B2EE8CF8B8E7F6C6955B9948023F5193ABE4298EC1AA65106E6BA3C8
create view "ods"."sv_mds_customermapping" as WITH source_mds_customermapping AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."MDS__mdm_CustomerMapping"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_customermapping
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;