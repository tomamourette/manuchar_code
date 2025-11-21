-- Auto Generated (Do not modify) 0349E9E6A51CF688AA899FF5A4EA9CB5A62478CAB7398B1CE93D70A956472FAD
create view "ods"."sv_mds_businesspartner" as WITH source_mds_businesspartner AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."MDS__mdm_BusinessPartner"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_businesspartner
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;