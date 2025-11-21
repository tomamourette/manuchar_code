WITH source_dbb_lakehouse_d365accounts_report AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY [d365_bcoa_hq_maneur], [d365_affiliates_e_g_pakistan] ORDER BY ingestion_timestamp DESC) AS rn
      FROM {{ source('dbb_lakehouse', 'D365_accounts_report') }}
),
 
deduplicated AS (
    SELECT *
      FROM source_dbb_lakehouse_d365accounts_report
     WHERE rn = 1
)
 
SELECT *
  FROM deduplicated