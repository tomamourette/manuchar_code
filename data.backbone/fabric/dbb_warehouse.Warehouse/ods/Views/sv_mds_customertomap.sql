-- Auto Generated (Do not modify) 1C288D7974DCC7C58A710C293975D93414C2E613328A134378A3C27C7A454FD9
create view "ods"."sv_mds_customertomap" as WITH source_mds_customertomap AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."MDS__mdm_CustomerToMap"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_customertomap
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;