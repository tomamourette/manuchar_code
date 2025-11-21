-- Auto Generated (Do not modify) 96439F497D43DF6674FE2FD4A1A5F39F5E20515D3BF1B5BF38305D9824B567D0
create view "mim"."bv_incoterm" as -- ===============================
-- STEP 1: Extracting Entity Data
-- From Different Sources
-- ===============================

WITH source_incoterm AS (
    SELECT
        hub.bkey_incoterm,
        hub.bkey_source,
        hub.bkey_incoterm AS incoterm_code,
        sat.incoterm_description,
        sat.valid_from,
        sat.valid_to
    FROM "dbb_warehouse"."mim"."rv_hub_incoterm" hub
    LEFT JOIN "dbb_warehouse"."mim"."rv_sat_incoterm" sat ON hub.bkey_incoterm_source = sat.bkey_incoterm_source
    WHERE sat.is_current = 1 -- add only the latest version
),

-- ===============================
-- STEP 2: Generating Non-overlapping 
-- Time Ranges for Each bkey
-- ===============================

time_ranges AS (
    SELECT
        bkey_incoterm,
        CAST(time_event AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(time_event) OVER (PARTITION BY bkey_incoterm ORDER BY time_event), '2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_incoterm, valid_from AS time_event FROM source_incoterm
        UNION 
        SELECT bkey_incoterm, valid_to AS time_event FROM source_incoterm
    ) AS time_events
    WHERE time_event <> '2999-12-31 23:59:59.999999'
)

-- ===============================
-- STEP 3: Combine Everything into a Timeline
-- Take One Leading Source for Each Attribute
-- ===============================

SELECT
    tr.bkey_incoterm,
    dyn.incoterm_code AS incoterm_code,
    dyn.incoterm_description AS incoterm_description,
    tr.valid_from,
    tr.valid_to,
    CASE
        WHEN tr.valid_to = CAST('2999-12-31 23:59:59.999999' AS DATETIME2(6)) THEN 1
        ELSE 0
    END AS is_current
FROM time_ranges tr

LEFT JOIN source_incoterm dyn
    ON dyn.bkey_incoterm = tr.bkey_incoterm
    AND dyn.valid_from <= tr.valid_from 
    AND COALESCE(dyn.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
    AND dyn.bkey_source = 'DYNAMICS' -- add only the source specific bkey's;