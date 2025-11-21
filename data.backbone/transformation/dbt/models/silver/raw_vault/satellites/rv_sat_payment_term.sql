WITH payment_term AS (
    SELECT 
        dyn.bkey_payment_term_source,
        dyn.bkey_payment_term AS payment_term_code,
        CAST(dyn.payment_term_description AS VARCHAR) AS payment_term_description,
        CAST(dyn.payment_term_number_of_days AS VARCHAR) AS payment_term_number_of_days,
        dyn.valid_from,
        dyn.valid_to,
        dyn.is_current
    FROM {{ ref('payment_term_dynamics') }} AS dyn

    UNION ALL

    SELECT 
        stg.bkey_payment_term_source,
        stg.bkey_payment_term AS payment_term_code,
        CAST(stg.payment_term_description AS VARCHAR) AS payment_term_description,
        CAST(stg.payment_term_number_of_days AS VARCHAR) AS payment_term_number_of_days,
        stg.valid_from,
        stg.valid_to,
        stg.is_current
    FROM {{ ref('payment_term_stg') }} AS stg
)

SELECT
    *
FROM payment_term