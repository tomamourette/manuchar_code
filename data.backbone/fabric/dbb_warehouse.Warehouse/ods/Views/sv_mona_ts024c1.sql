-- Auto Generated (Do not modify) 0DB69C84945A30E43F2354A19D0D51101B80D9ECCAFF4AF954C776B5B5F1D355
create view "ods"."sv_mona_ts024c1" as WITH source_mona_ts024c1 AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY CountryCustomerID ORDER BY ODSIngestionDate DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."Mona__dbo_TS024C1"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_mona_ts024c1
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;