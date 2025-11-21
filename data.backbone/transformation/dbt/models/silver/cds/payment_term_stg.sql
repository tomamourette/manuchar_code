-- ===============================
-- STEP 1: Extracting Current Payment Term Data (SCD1)
-- ===============================

WITH stg_payment_term_current AS (
    SELECT DISTINCT
        bkey_payment_term_source,
        bkey_payment_term,
        bkey_source,
        CAST('1900-01-01 00:00:00.000000' AS DATETIME2(6)) AS valid_from,
        CAST('2999-12-31 23:59:59.999999' AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT DISTINCT
            TRIM(PaymentTerm) + '_STG' AS bkey_payment_term_source,
            TRIM(PaymentTerm) AS bkey_payment_term,
            'STG' AS bkey_source
        FROM {{ ref("sv_stg_stg_ar_invoices_hist") }}

        UNION

        SELECT DISTINCT
            TRIM(PaymentTerm) + '_STG' AS bkey_payment_term_source,
            TRIM(PaymentTerm) AS bkey_payment_term,
            'STG' AS bkey_source
        FROM {{ ref("sv_stg_stg_ap_invoices_hist") }}
    ) t
),

-- ===============================
-- STEP 2: Generate Time Ranges for SCD2
-- Consolidate timestamps from the current payment term data into a unified timeline
-- ===============================

timeranges AS (
    SELECT 
        bkey_payment_term_source,
        bkey_payment_term,
        bkey_source,
        CAST(valid_from AS DATETIME2(6)) AS valid_from,
        CAST(LEAD(valid_from, 1, '2999-12-31 23:59:59.999999') OVER (PARTITION BY bkey_payment_term_source ORDER BY valid_from) AS DATETIME2(6)) AS valid_to
    FROM stg_payment_term_current
)

-- ===============================
-- STEP 3: Combine Everything into a Full Payment Term Timeline
-- Join the unified timeline with the current payment term data on ID and effective time range
-- ===============================
SELECT 
    tr.bkey_payment_term_source,
    tr.bkey_payment_term,
    tr.bkey_source,
    NULL AS payment_term_description,
    NULL AS payment_term_number_of_days,
    tr.valid_from,
    tr.valid_to,
    CASE 
        WHEN tr.valid_to = '2999-12-31 23:59:59.999999' THEN 1 
        ELSE 0
    END AS is_current
FROM timeranges tr
LEFT JOIN stg_payment_term_current pc 
ON pc.bkey_payment_term = tr.bkey_payment_term
AND pc.valid_from <= tr.valid_from 
AND COALESCE(pc.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from