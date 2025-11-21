-- Auto Generated (Do not modify) 63E5011F379507D426E5D738776A8C1DEF0B5D6266479D8AD54E1083BDAF514B
create view "ods"."sv_boomi_location" as WITH source_boomi_location AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY LocationCode ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Boomi__dbo_Locations"
),

deduplicated AS (
    SELECT 
        *
    FROM source_boomi_location
    WHERE rn = 1
)

SELECT 
    *
FROM deduplicated;