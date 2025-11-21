WITH journal_mapping AS (
    SELECT
        bkey_journal_mapping_source,
        bkey_journal_mapping,
        bkey_source,
        journal_mapping_code,
        allocation,
        bundle,
        bundle_local_adjustments,
        conso_adjusted,
        conso_legal,
        intercompany,
        manual,
        technical_eliminations,
        valid_from,
        valid_to,
        is_current
    FROM {{ ref('journal_mapping_oil_monaconso') }}
)

SELECT 
    *
FROM journal_mapping