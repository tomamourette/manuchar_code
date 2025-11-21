-- Auto Generated (Do not modify) DB4EA3B9429737E96EAA89B7F2809D52366A0059AA48D3416AF049B220F32DD1
create view "mim"."bv_customer_industry_invoice" as -- ===============================
-- STEP 1: Extracting Entity Data
-- From Different Sources
-- ===============================

WITH source_customer_industry_invoice AS (
    SELECT
        hub.bkey_customer_industry_invoice,
        hub.bkey_source,
        sat.customer_industry_invoice_name,
        sat.customer_industry_invoice_group,
        sat.valid_from,
        sat.valid_to
    FROM "dbb_warehouse"."mim"."rv_hub_customer_industry_invoice" hub
    LEFT JOIN "dbb_warehouse"."mim"."rv_sat_customer_industry_invoice" sat ON hub.bkey_customer_industry_invoice_source = sat.bkey_customer_industry_invoice_source
    WHERE is_current = 1 -- add only the latest version
),

-- ===============================
-- STEP 2: Generating Non-overlapping 
-- Time Ranges for Each customer_industry_invoice
-- ===============================

time_ranges AS (
    SELECT
        bkey_customer_industry_invoice,
        CAST(time_event AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(time_event) OVER (PARTITION BY bkey_customer_industry_invoice ORDER BY time_event), '2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_customer_industry_invoice, valid_from AS time_event FROM source_customer_industry_invoice
        UNION 
        SELECT bkey_customer_industry_invoice, valid_to AS time_event FROM source_customer_industry_invoice
    ) AS time_events
    WHERE time_event <> '2999-12-31 23:59:59.999999'
)

-- ===============================
-- STEP 3: Combining Data into a Unified Timeline
-- Selecting the Leading Source for Each Attribute
-- ===============================

SELECT
    tr.bkey_customer_industry_invoice,
    mds.customer_industry_invoice_name AS customer_industry_invoice_name,
    mds.customer_industry_invoice_group,
    tr.valid_from,
    tr.valid_to,
    CASE
        WHEN tr.valid_to = CAST('2999-12-31 23:59:59.999999' AS DATETIME2(6)) THEN 1
        ELSE 0
    END AS is_current
FROM time_ranges tr

LEFT JOIN source_customer_industry_invoice mds
    ON mds.bkey_customer_industry_invoice = tr.bkey_customer_industry_invoice 
    AND mds.valid_from <= tr.valid_from 
    AND COALESCE(mds.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
    AND mds.bkey_source = 'MDS' -- add only the source specific bkey's

LEFT JOIN source_customer_industry_invoice dyn
    ON dyn.bkey_customer_industry_invoice = tr.bkey_customer_industry_invoice 
    AND dyn.valid_from <= tr.valid_from 
    AND COALESCE(dyn.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
    AND dyn.bkey_source = 'DYNAMICS' -- add only the source specific bkey's;