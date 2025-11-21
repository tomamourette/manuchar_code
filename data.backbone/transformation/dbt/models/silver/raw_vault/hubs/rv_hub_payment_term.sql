WITH source_dynamics_paymterm AS (
    SELECT 
        bkey_payment_term_source,
        bkey_payment_term,
        bkey_source,
        CAST(ptd.valid_from AS DATETIME2(6)) AS ldts,
        CAST('Dynamics 365' AS VARCHAR(25)) AS record_source
    FROM {{ ref('payment_term_dynamics') }} AS ptd
), 

source_stg_paymterm AS (
    SELECT 
        bkey_payment_term_source,
        bkey_payment_term,
        bkey_source,
        CAST(ptd.valid_from AS DATETIME2(6)) AS ldts,
        CAST('STG' AS VARCHAR(25)) AS record_source
    FROM {{ ref('payment_term_stg') }} AS ptd
),

sources_combined AS (
    SELECT 
        bkey_payment_term_source,
        bkey_payment_term,
        bkey_source,
        ldts,
        record_source
    FROM source_dynamics_paymterm

    UNION ALL

        SELECT 
        bkey_payment_term_source,
        bkey_payment_term,
        bkey_source,
        ldts,
        record_source
    FROM source_stg_paymterm
), 

sources_deduplicated AS (
    SELECT 
        bkey_payment_term_source,
        bkey_payment_term,
        bkey_source,
        ldts,
        record_source,
        ROW_NUMBER() OVER (PARTITION BY bkey_payment_term_source ORDER BY ldts ASC) AS row_number
    FROM sources_combined
)

SELECT 
    bkey_payment_term_source,
    bkey_payment_term,
    bkey_source,
    ldts,
    record_source
FROM sources_deduplicated
WHERE row_number = 1