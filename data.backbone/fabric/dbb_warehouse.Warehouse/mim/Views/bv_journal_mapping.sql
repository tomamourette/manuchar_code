-- Auto Generated (Do not modify) F1EEB6AE7B80C59E37D4AAD6B4604ED0D193A9F81EF5B922CAAD8F9343A2B296
create view "mim"."bv_journal_mapping" as WITH source_journal_mapping AS (
    SELECT
        sat.bkey_journal_mapping,
        sat.bkey_source,
        sat.journal_mapping_code,
        sat.allocation,
        sat.bundle,
        sat.bundle_local_adjustments,
        sat.conso_adjusted,
        sat.conso_legal,
        sat.intercompany,
        sat.manual,
        sat.technical_eliminations,
        sat.valid_from,
        sat.valid_to,
        sat.is_current
    FROM "dbb_warehouse"."mim"."rv_sat_journal_mapping" sat
)

SELECT
    *
FROM source_journal_mapping;