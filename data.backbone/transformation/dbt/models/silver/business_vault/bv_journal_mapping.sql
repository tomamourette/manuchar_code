WITH source_journal_mapping AS (
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
    FROM {{ ref('rv_sat_journal_mapping')}} sat
)

SELECT
    *
FROM source_journal_mapping