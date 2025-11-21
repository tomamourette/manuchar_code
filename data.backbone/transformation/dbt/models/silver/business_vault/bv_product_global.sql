-- ===============================
-- STEP 1: Extracting Entity Data
-- From Different Sources
-- ===============================

WITH source_product AS (
    SELECT
        hub.bkey_product_global,
        hub.bkey_source,
        sat.product_global_name,
        sat.product_group,
        sat.product_group_category,
        sat.product_group_subcategory,
        sat.product_business_unit,
        COALESCE(sat.valid_from,'1900-01-01 23:59:59.999999') as valid_from,
        sat.valid_to
    FROM {{ ref('rv_hub_product_global')}} hub
    LEFT JOIN {{ ref('rv_sat_product_global')}} sat ON hub.bkey_product_global_source = sat.bkey_product_global_source
    WHERE sat.is_current = 1 -- add only the latest version
),

-- ===============================
-- STEP 2: Generating Non-overlapping 
-- Time Ranges for Each bkey_customer
-- ===============================

time_ranges AS (
    SELECT
        bkey_product_global,
        CAST(time_event AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(time_event) OVER (PARTITION BY bkey_product_global ORDER BY time_event),'2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_product_global, valid_from AS time_event FROM source_product
        UNION
        SELECT bkey_product_global, valid_to AS time_event FROM source_product
    ) AS time_events
    WHERE time_event <> '2999-12-31 23:59:59.999999'
)

-- ===============================
-- STEP 3: Combine Everything into a Timeline
-- Take One Leading Source for Each Attribute
-- ===============================

SELECT
    tr.bkey_product_global,
    COALESCE(mds.product_group, dyn.product_group) AS product_group,
    COALESCE(mds.product_group_category, dyn.product_group_category) AS product_group_category,
    COALESCE(mds.product_group_subcategory, dyn.product_group_subcategory) AS product_group_subcategory,
    COALESCE(mds.product_business_unit, dyn.product_business_unit) AS product_business_unit,
    COALESCE(mds.product_global_name, dyn.product_global_name) AS product_global_name,
    CASE 
        WHEN COALESCE(mds.product_group_category, dyn.product_group_category) = 'Core' 
        THEN 1 
        ELSE 0 
    END AS product_core,
    tr.valid_from,
    tr.valid_to,
    CASE
        WHEN tr.valid_to = CAST('2999-12-31 23:59:59.999999' AS DATETIME2(6))
            THEN 1
        ELSE 0
    END AS is_current
FROM time_ranges tr

LEFT JOIN source_product mds
ON mds.bkey_product_global = tr.bkey_product_global
AND mds.valid_from <= tr.valid_from 
AND COALESCE(mds.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
AND mds.bkey_source = 'MDS' -- add only the source specific bkey's

LEFT JOIN source_product dyn
ON dyn.bkey_product_global = tr.bkey_product_global
AND dyn.valid_from <= tr.valid_from 
AND COALESCE(dyn.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
AND dyn.bkey_source = 'DYNAMICS' -- add only the source specific bkey's