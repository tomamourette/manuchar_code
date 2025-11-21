-- Auto Generated (Do not modify) AE4E91E80C489FF892199162A0610DA95A243300A09DC37FCF0F6121A9443A38
create view "ods"."sv_mds_companies" as WITH source_mds_companies AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."MDS__mdm_Companies"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_companies
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;