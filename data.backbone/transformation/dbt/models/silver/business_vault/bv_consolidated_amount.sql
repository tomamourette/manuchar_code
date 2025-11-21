WITH source_consolidated_amount AS (
    SELECT 
        hub.bkey_consolidated_amount,
        hub.bkey_source,
        sat.consolidated_account,
        sat.consolidated_consolidation_period,
        sat.consolidated_company,
        sat.consolidated_currency,
        sat.consolidated_partner_company,
        sat.consolidated_industry,
        sat.consolidated_journal_type,
        sat.consolidated_journal_category,
        sat.consolidated_amount,
        sat.consolidated_bundle_local_adjustment_amount,
        sat.consolidated_bundle_local_amount,
        sat.valid_from,
        sat.valid_to,
        sat.is_current
    FROM {{ ref('rv_hub_consolidated_amount') }} AS hub
    LEFT JOIN {{ ref('rv_sat_consolidated_amount') }} AS sat 
        ON hub.bkey_consolidated_amount_source = sat.bkey_consolidated_amount_source
)

SELECT 
    *
FROM source_consolidated_amount