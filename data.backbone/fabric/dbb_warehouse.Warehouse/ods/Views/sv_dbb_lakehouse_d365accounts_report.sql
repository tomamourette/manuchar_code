-- Auto Generated (Do not modify) D5C18FA5DC63262C86F51729D175A3726EF33CC67EA388D3E75C2B27A1F96BC8
create view "ods"."sv_dbb_lakehouse_d365accounts_report" as WITH source_dbb_lakehouse_d365accounts_report AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY [d365_bcoa_hq_maneur], [d365_affiliates_e_g_pakistan] ORDER BY ingestion_timestamp DESC) AS rn
      FROM "dbb_lakehouse"."dbo"."dbb_lakehouse__dbo_enum_d365accounts_report"
),
 
deduplicated AS (
    SELECT *
      FROM source_dbb_lakehouse_d365accounts_report
     WHERE rn = 1
)
 
SELECT *
  FROM deduplicated;