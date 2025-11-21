{{ config(
    tags=['Group-FinancialStatements', 'Fact', 'Currency Rates']
) }}

SELECT
    dat.tkey_date,
    cur.tkey_currency,

    cr.currency_rate_consolidation_code,
    cr.currency_rate_reference_currency_code,
    cr.currency_rate_closing_rate,
    cr.currency_rate_average_rate,
    cr.currency_rate_average_month,
    cr.currency_rate_budget_closing_rate,
    cr.currency_rate_budget_average_rate,
    cr.currency_rate_budget_average_month

FROM {{ ref('bv_currency_rate')}} cr
LEFT JOIN {{ ref('dim_date') }} dat ON FORMAT(EOMONTH(CONVERT(date, LEFT(cr.currency_rate_consolidation_code, 6) + '01')), 'yyyyMMdd') = dat.bkey_date
LEFT JOIN {{ ref('dim_currency') }} cur ON cur.bkey_currency = cr.currency_rate_currency_code
WHERE cr.is_current = 1 -- add only the latest version