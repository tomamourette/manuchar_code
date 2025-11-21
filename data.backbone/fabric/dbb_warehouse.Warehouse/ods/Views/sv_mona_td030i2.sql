-- Auto Generated (Do not modify) 0B932496DC7BF52DE0BA3F7CB00F53F825D4C4F42AB3DE1D95C1B94F4F397D22
create view "ods"."sv_mona_td030i2" as WITH source_mona_td030i2 AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY LocalPartnerID, ConsoID ORDER BY ConsoID, ODSIngestionDate DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Mona__dbo_TD030I2"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_td030i2
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;