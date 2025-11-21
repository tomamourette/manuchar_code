-- Auto Generated (Do not modify) 4D7BC1D09F35295BDCC805D548E6EBE37C35CCD67ABDD780F4BFF07D42860834
create view "ods"."sv_mds_businesstypes" as WITH source_mds_businesstypes AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."MDS__mdm_BusinessTypes"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_businesstypes
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;