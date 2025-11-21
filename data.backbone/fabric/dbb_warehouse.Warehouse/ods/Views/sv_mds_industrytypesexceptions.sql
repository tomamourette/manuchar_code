-- Auto Generated (Do not modify) 55EC25D48AA91916374C752177D6C59239B704832C633D552BE1CE7243497B49
create view "ods"."sv_mds_industrytypesexceptions" as WITH source_mds_industrytypesexceptions AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."MDS__mdm_IndustryTypesExceptions"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_industrytypesexceptions
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;