WITH consolidation_period AS (
    SELECT
        bkey_consolidation_period_source,
        consolidation_id,
        consolidation_name,
        consolidation_year,
        consolidation_month,
        consolidation_date,
        consolidation_version,
        consolidation_category,
        consolidation_category_description,
        consolidation_scope,
        consolidation_l4l_scope,
        valid_from,
        valid_to,
        is_current
    FROM {{ ref('consolidation_period_mona') }}
)
SELECT 
    *
FROM consolidation_period