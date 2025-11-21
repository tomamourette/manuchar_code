WITH consolidated_amount AS (
    SELECT
        bkey_consolidated_amount_source,
        consolidated_account,
        consolidated_consolidation_period,
        consolidated_company,
        consolidated_currency,
        consolidated_partner_company,
        consolidated_industry,
        consolidated_journal_type,
        consolidated_journal_category,
        consolidated_amount,
        consolidated_bundle_local_adjustment_amount,
        consolidated_bundle_local_amount,
        valid_from,
        valid_to,
        is_current
    FROM {{ ref('consolidated_amount_mona') }}
)

SELECT 
    *
FROM consolidated_amount