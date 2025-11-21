-- ===============================
-- STEP 1: Extracting Entity Data
-- From Different Sources
-- ===============================

WITH source_customer AS (
    SELECT
        hub.bkey_customer,
        hub.bkey_source,
        sat.bkey_customer_global,
        sat.customer_id,
        sat.customer_name,
        sat.customer_company,
        sat.customer_group,
        sat.customer_group_description,
        sat.customer_legal_number,
        sat.customer_address,
        sat.customer_city,
        sat.customer_zip_code,
        sat.customer_industry,
        sat.customer_multinational_legal_number,
        sat.customer_multinational_name,
        sat.customer_gkam,
        sat.customer_affiliate,
        sat.customer_country_code,
        sat.valid_from,
        sat.valid_to
    FROM {{ ref('rv_hub_customer') }} hub
    LEFT JOIN {{ ref('rv_sat_customer') }} sat ON hub.bkey_customer_source = sat.bkey_customer_source
    -- WHERE is_current = 1 -- add only the latest version
),

-- ===============================
-- STEP 2: Generating Non-overlapping 
-- Time Ranges for Each bkey_customer
-- ===============================

time_ranges AS (
    SELECT
        bkey_customer,
        CAST(time_event AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(time_event) OVER (PARTITION BY bkey_customer ORDER BY time_event),'2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_customer, valid_from AS time_event FROM source_customer
        UNION
        SELECT bkey_customer, valid_to AS time_event FROM source_customer
    ) AS time_events
    WHERE time_event <> '2999-12-31 23:59:59.999999'
)

-- ===============================
-- STEP 3: Combine Everything into a Timeline
-- Take One Leading Source for Each Attribute
-- ===============================

SELECT
    tr.bkey_customer,
    COALESCE(mds.bkey_customer_global, dyn.bkey_customer_global) AS bkey_customer_global,
    COALESCE(mds.customer_company, dyn.customer_company) AS customer_company,
    dyn.customer_group,
    dyn.customer_group_description,
    COALESCE(mds.customer_id, dyn.customer_id) AS customer_id,
    COALESCE(mds.customer_legal_number, dyn.customer_legal_number) AS customer_legal_number,
    COALESCE(mds.customer_multinational_legal_number, dyn.customer_multinational_legal_number) AS customer_multinational_legal_number,
    COALESCE(mds.customer_multinational_name, dyn.customer_multinational_name) AS customer_multinational_name,
    COALESCE(mds.customer_name, dyn.customer_name) AS customer_name,
    COALESCE(mds.customer_address, dyn.customer_address) AS customer_address,
    COALESCE(mds.customer_city, dyn.customer_city) AS customer_city,
    COALESCE(mds.customer_zip_code, dyn.customer_zip_code) AS customer_zip_code,
    COALESCE(mds.customer_industry, dyn.customer_industry) AS customer_industry,
    COALESCE(mds.customer_gkam, dyn.customer_gkam) AS customer_gkam,
    COALESCE(mds.customer_affiliate, dyn.customer_affiliate) AS customer_affiliate,
    COALESCE(mds.customer_country_code, dyn.customer_country_code) AS customer_country_code,
    tr.valid_from,
    tr.valid_to,
    CASE
        WHEN tr.valid_to = CAST('2999-12-31 23:59:59.999999' AS DATETIME2(6))
            THEN 1
        ELSE 0
    END AS is_current
FROM time_ranges tr

LEFT JOIN source_customer mds
ON mds.bkey_customer = tr.bkey_customer 
AND mds.valid_from <= tr.valid_from 
AND COALESCE(mds.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
AND mds.bkey_source = 'MDS' -- add only the source specific bkey's

LEFT JOIN source_customer dyn
ON dyn.bkey_customer = tr.bkey_customer 
AND dyn.valid_from <= tr.valid_from 
AND COALESCE(dyn.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
AND dyn.bkey_source = 'DYNAMICS' -- add only the source specific bkey's