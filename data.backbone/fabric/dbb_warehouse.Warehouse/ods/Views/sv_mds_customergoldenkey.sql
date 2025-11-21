-- Auto Generated (Do not modify) 990EC14626046D105D2A4F6F2EEB636FF06F429F8EBAFB0266C6ADCE227F5E43
create view "ods"."sv_mds_customergoldenkey" as WITH source_mds_customergoldenkey AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."MDS__mdm_CustomerGoldenKey"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_customergoldenkey
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;