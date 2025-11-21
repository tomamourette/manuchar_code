-- Auto Generated (Do not modify) 8DA059AC4D86860FD52243991A90F6F193B12D290EBED48CBA421ABEDA8F690D
create view "mim"."bv_product" as -- ===============================
-- STEP 1: Extracting Entity Data
-- From Different Sources
-- ===============================

WITH source_product AS (
    SELECT
        hub.bkey_product,
        hub.bkey_source,
        sat.product_name,
        sat.product_global_code,
        sat.product_company,
        sat.product_id,
        COALESCE(sat.valid_from,'1900-01-01 23:59:59.999999') as valid_from,
        sat.valid_to
    FROM "dbb_warehouse"."mim"."rv_hub_product" hub
    LEFT JOIN "dbb_warehouse"."mim"."rv_sat_product" sat ON hub.bkey_product_source = sat.bkey_product_source
    WHERE sat.is_current = 1 -- add only the latest version
),

-- ===============================
-- STEP 2: Generating Non-overlapping 
-- Time Ranges for Each bkey_customer
-- ===============================

time_ranges AS (
    SELECT
        bkey_product,
        CAST(time_event AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(time_event) OVER (PARTITION BY bkey_product ORDER BY time_event),'2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_product, valid_from AS time_event FROM source_product
        UNION
        SELECT bkey_product, valid_to AS time_event FROM source_product
    ) AS time_events
    WHERE time_event <> '2999-12-31 23:59:59.999999'
)

-- ===============================
-- STEP 3: Combine Everything into a Timeline
-- Take One Leading Source for Each Attribute
-- ===============================

SELECT
    tr.bkey_product,
    COALESCE(mds.product_name, dyn.product_name) AS product_name,
    COALESCE(mds.product_global_code, dyn.product_global_code) AS product_global_code,
    COALESCE(mds.product_company, dyn.product_company) AS product_company,
    COALESCE(mds.product_id, dyn.product_id) AS product_id,
    tr.valid_from,
    tr.valid_to,
    CASE
        WHEN tr.valid_to = CAST('2999-12-31 23:59:59.999999' AS DATETIME2(6))
            THEN 1
        ELSE 0
    END AS is_current
FROM time_ranges tr

LEFT JOIN source_product mds
ON mds.bkey_product = tr.bkey_product
AND mds.valid_from <= tr.valid_from 
AND COALESCE(mds.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
AND mds.bkey_source = 'MDS' -- add only the source specific bkey's

LEFT JOIN source_product dyn
ON dyn.bkey_product = tr.bkey_product
AND dyn.valid_from <= tr.valid_from 
AND COALESCE(dyn.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
AND dyn.bkey_source = 'DYNAMICS' -- add only the source specific bkey's;