-- Auto Generated (Do not modify) 7564FD8C51D70890F32FE88F4349A56C2406AB2399B2A502924E922AA6B05F6E
create view "ods"."sv_mds_locations" as WITH source_mds_locations AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY Code ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."MDS__mdm_Locations"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mds_locations
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;