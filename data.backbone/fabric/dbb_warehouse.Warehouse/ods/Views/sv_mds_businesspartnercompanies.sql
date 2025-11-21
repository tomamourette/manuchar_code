-- Auto Generated (Do not modify) 17497D6FB356F42FB5D211A86BF2F2780A42879A6F84584639DB3BBD1F1AD384
create view "ods"."sv_mds_businesspartnercompanies" as WITH source_mds_businesspartnercompanies AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."MDS__mdm_BusinessPartnerCompanies"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_businesspartnercompanies
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;