-- Auto Generated (Do not modify) B109CF10886BFED44FF00DD70D47EE58E54492D1E59E2A22F237901346A68ECF
create view "ods"."sv_boomi_site" as WITH source_boomi_site AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY SiteCode ORDER BY ingestion_timestamp DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Boomi__dbo_Sites"
),

deduplicated AS (
    SELECT
        *
    FROM source_boomi_site
    WHERE rn = 1
)

SELECT
    *
FROM deduplicated;