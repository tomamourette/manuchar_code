-- Auto Generated (Do not modify) 174296FB2DEA7E7C304B52A5290D282113B57A8DE2F51D1E8738A3BB88FAC062
create view "ods"."sv_mona_v_dimensiongroup" as WITH source_mona_v_dimensiongroup AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY DimensionGroupID, ConsoID ORDER BY ConsoID, ODSIngestionDate DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Mona__dbo_V_DIMENSIONGROUP"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_v_dimensiongroup
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;