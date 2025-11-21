-- ===============================
-- STEP 1: Extracting Current Payment Term Data (SCD1)
-- Retrieve the latest record per payment term using ROW_NUMBER()
-- and then recalculate valid_to on the filtered (rn=1) data
-- ===============================
WITH dynamics_payment_term_current AS (
    SELECT 
        bkey_payment_term_source,
        bkey_payment_term,
        bkey_source,
        paymenttermcode,
        paymenttermdescription,
        numberofdays,
        valid_from,
        CAST(LEAD(valid_from, 1, '2999-12-31 23:59:59.999999') OVER (PARTITION BY bkey_payment_term_source ORDER BY valid_from) AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT 
            paymtermid + '_DYNAMICS' AS bkey_payment_term_source,
            paymtermid AS bkey_payment_term,
            'DYNAMICS' AS bkey_source,
            paymtermid AS paymenttermcode,
            description AS paymenttermdescription,
            numofdays AS numberofdays,
            CAST(modifieddatetime AS DATETIME2(6)) AS valid_from,
            ROW_NUMBER() OVER (PARTITION BY paymtermid ORDER BY modifieddatetime DESC) AS rn
        FROM {{ ref("sv_dynamics_paymterm") }}
    ) t
    WHERE rn = 1
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
    FROM dynamics_payment_term_current
)

-- ===============================
-- STEP 3: Combine Everything into a Full Payment Term Timeline
-- Join the unified timeline with the current payment term data on ID and effective time range
-- ===============================
SELECT 
    tr.bkey_payment_term_source,
    tr.bkey_payment_term,
    tr.bkey_source,
    pc.paymenttermdescription as payment_term_description,
    pc.numberofdays as payment_term_number_of_days,
    tr.valid_from,
    tr.valid_to,
    CASE 
        WHEN tr.valid_to = '2999-12-31 23:59:59.999999' THEN 1 
        ELSE 0
    END AS is_current
FROM timeranges tr
LEFT JOIN dynamics_payment_term_current pc 
ON pc.bkey_payment_term = tr.bkey_payment_term
AND pc.valid_from <= tr.valid_from 
AND COALESCE(pc.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from;
