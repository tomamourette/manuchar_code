-- Auto Generated (Do not modify) F52F9A1891F2F2DECA617140B68C8BF2062199B4962871C55189487F324E7E9C
create view "mim"."bv_account" as -- ===============================
-- STEP 1: Extracting Entity Data
-- From Different Sources in a Single CTE
-- ===============================

WITH source_account AS (
    SELECT
        hub.bkey_account,
        hub.bkey_source,
        sat.account_number,
        sat.account_description,
        sat.account_type,
        sat.account_reporting_sign,
        sat.account_running_total_sign,
        sat.valid_from,
        sat.valid_to
    FROM "dbb_warehouse"."mim"."rv_hub_account" hub
    LEFT JOIN "dbb_warehouse"."mim"."rv_sat_account" sat ON hub.bkey_account_source = sat.bkey_account_source
    WHERE sat.is_current = 1 -- add only the latest version
),

-- ===============================
-- STEP 2: Generating Non-overlapping 
-- Time Ranges for Each bkey
-- ===============================

time_ranges AS (
    SELECT
        bkey_account,
        CAST(time_event AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(time_event) OVER (PARTITION BY bkey_account ORDER BY time_event), '2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_account, valid_from AS time_event FROM source_account
        UNION 
        SELECT bkey_account, valid_to AS time_event FROM source_account
    ) AS time_events
    WHERE time_event <> '2999-12-31 23:59:59.999999'
)

-- ===============================
-- STEP 3: Combine Everything into a Timeline
-- Take One Leading Source for Each Attribute
-- ===============================

SELECT
    tr.bkey_account,
    mds.account_number,
    mds.account_description,
    mds.account_type,
    mds.account_reporting_sign,
    mds.account_running_total_sign,
    tr.valid_from,
    tr.valid_to,
    CASE
        WHEN tr.valid_to = CAST('2999-12-31 23:59:59.999999' AS DATETIME2(6)) THEN 1
        ELSE 0
    END AS is_current
FROM time_ranges tr

LEFT JOIN source_account mds
    ON mds.bkey_account = tr.bkey_account 
    AND mds.valid_from <= tr.valid_from 
    AND COALESCE(mds.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
    AND mds.bkey_source = 'MDS' -- add only the source specific bkey's;