-- Auto Generated (Do not modify) 378B32087D44AC04F74758BAEA8184B0BD228C18427949E6BEB2D21B7C3E2EBC
create view "mim"."bv_payment_term" as -- ===============================
-- STEP 1: Extracting Entity Data
-- From Different Sources
-- ===============================

WITH source_payment_term AS (
    SELECT
        hub.bkey_payment_term,
        hub.bkey_source,
        hub.bkey_payment_term AS payment_term_code,
        sat.payment_term_description,
        sat.payment_term_number_of_days,
        sat.valid_from,
        sat.valid_to
    FROM "dbb_warehouse"."mim"."rv_hub_payment_term" hub
    LEFT JOIN "dbb_warehouse"."mim"."rv_sat_payment_term" sat ON hub.bkey_payment_term_source = sat.bkey_payment_term_source
    WHERE sat.is_current = 1 -- add only the latest version
),

-- ===============================
-- STEP 2: Generating Non-overlapping 
-- Time Ranges for Each bkey
-- ===============================

time_ranges AS (
    SELECT
        bkey_payment_term,
        CAST(time_event AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(time_event) OVER (PARTITION BY bkey_payment_term ORDER BY time_event), '2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_payment_term, valid_from AS time_event FROM source_payment_term
        UNION 
        SELECT bkey_payment_term, valid_to AS time_event FROM source_payment_term
    ) AS time_events
    WHERE time_event <> '2999-12-31 23:59:59.999999'
)

-- ===============================
-- STEP 3: Combine Everything into a Timeline
-- Take One Leading Source for Each Attribute
-- ===============================

SELECT
    tr.bkey_payment_term,
    COALESCE(dyn.payment_term_code, stg.payment_term_code) AS payment_term_code,
    COALESCE(dyn.payment_term_description, stg.payment_term_description) AS payment_term_description,
    COALESCE(dyn.payment_term_number_of_days, stg.payment_term_number_of_days) AS payment_term_number_of_days,
    tr.valid_from,
    tr.valid_to,
    CASE
        WHEN tr.valid_to = CAST('2999-12-31 23:59:59.999999' AS DATETIME2(6)) THEN 1
        ELSE 0
    END AS is_current
FROM time_ranges tr

LEFT JOIN source_payment_term dyn
    ON dyn.bkey_payment_term = tr.bkey_payment_term
    AND dyn.valid_from <= tr.valid_from 
    AND COALESCE(dyn.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
    AND dyn.bkey_source = 'DYNAMICS' -- add only the source specific bkey's

LEFT JOIN source_payment_term stg
    ON stg.bkey_payment_term = tr.bkey_payment_term
    AND stg.valid_from <= tr.valid_from 
    AND COALESCE(stg.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
    AND stg.bkey_source = 'STG' -- add only the source specific bkey's;