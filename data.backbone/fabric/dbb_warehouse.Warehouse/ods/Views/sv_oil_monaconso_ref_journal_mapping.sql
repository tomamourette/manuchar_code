-- Auto Generated (Do not modify) F7BC00344F268A96AA8AD8E656EDFE7F5E4ABCCAF1E687CA4E7A721B0585BE6D
create view "ods"."sv_oil_monaconso_ref_journal_mapping" as WITH source_oil_monaconso_ref_journal_mapping AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY journal ORDER BY journal DESC) AS rn
    FROM "dbb_lakehouse"."dbo"."OIL_MonaConso__REF_JOURNAL_MAPPING"
),
 
deduplicated AS (
    SELECT
        *
    FROM source_oil_monaconso_ref_journal_mapping
    WHERE rn = 1
)
 
SELECT
    *
FROM deduplicated;