-- Auto Generated (Do not modify) D8CA18ADDB7A006422BEDCC143E06A2C3B367AB1AD5FF0E8CC3E8B4F2207FA3E
create view "ods"."sv_oil_monaconso_ref_conso_reporting_category" as WITH source_oil_mona_conso_ref_conso_reporting_category AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY category_mona, version_mona, valid_to ORDER BY valid_to DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."OIL_MonaConso__REF_CONSO_REPORTING_CATEGORY"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_oil_mona_conso_ref_conso_reporting_category
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;