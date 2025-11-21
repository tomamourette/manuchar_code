-- Auto Generated (Do not modify) 2857B9ADA4B64F9B2A3AA357288C6D4A78A1A35E8E76547AF08243EE5D511561
create view "ods"."sv_mona_v_dimensiondetail" as WITH source_mona_v_dimensiondetail AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY DimensionDetailID, ConsoID ORDER BY ConsoID, ODSIngestionDate DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Mona__dbo_V_DIMENSIONDETAIL"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_v_dimensiondetail
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;