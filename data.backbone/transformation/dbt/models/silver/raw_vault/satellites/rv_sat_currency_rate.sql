WITH currency_rate AS (
    SELECT
        bkey_currency_rate_source,
        currency_rate_consolidation_id,
        currency_rate_consolidation_code,
        currency_rate_currency_code,
        currency_rate_reference_currency_code,
        currency_rate_closing_rate,
        currency_rate_average_rate,
        currency_rate_average_month,
        currency_rate_budget_closing_rate,
        currency_rate_budget_average_rate,
        currency_rate_budget_average_month,
        currency_rate_month,
        currency_rate_year,
        currency_rate_closing_date,
        valid_from,
        valid_to,
        is_current
    FROM {{ ref('currency_rate_mona') }}
)

SELECT 
    *
FROM currency_rate