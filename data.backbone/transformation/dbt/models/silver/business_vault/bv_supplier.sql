-- ===============================
-- STEP 1: Extracting Entity Data
-- From Different Sources
-- ===============================

WITH source_supplier AS (
    SELECT
        hub.bkey_supplier,
        hub.bkey_source,
        sat.bkey_supplier_global,
        sat.supplier_group,
        sat.supplier_group_description,
        sat.supplier_name,
        sat.supplier_id,
        sat.supplier_company,
        sat.supplier_address,
        sat.supplier_city,
        sat.supplier_zip_code,
        sat.supplier_affiliate,
        sat.supplier_country_code,
        sat.supplier_legal_number,
        sat.valid_from,
        sat.valid_to
    FROM {{ ref('rv_hub_supplier')}} hub
    LEFT JOIN {{ ref('rv_sat_supplier')}} sat ON hub.bkey_supplier_source = sat.bkey_supplier_source
    -- WHERE is_current = 1 -- add only the latest version
),

-- ===============================
-- STEP 2: Generating Non-overlapping 
-- Time Ranges for Each bkey
-- ===============================

time_ranges AS (
    SELECT
        bkey_supplier,
        CAST(time_event AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(time_event) OVER (PARTITION BY bkey_supplier ORDER BY time_event), '2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_supplier, valid_from AS time_event FROM source_supplier
        UNION 
        SELECT bkey_supplier, valid_to AS time_event FROM source_supplier
    ) AS time_events
    WHERE time_event <> '2999-12-31 23:59:59.999999'
)

-- ===============================
-- STEP 3: Combine Everything into a Timeline
-- Take One Leading Source for Each Attribute
-- ===============================

SELECT
    tr.bkey_supplier,
    COALESCE(dyn.bkey_supplier_global, mds.bkey_supplier_global) AS bkey_supplier_global,
    COALESCE(dyn.supplier_group, mds.supplier_group) AS supplier_group,
    COALESCE(dyn.supplier_group_description, mds.supplier_group_description) AS supplier_group_description,
    COALESCE(dyn.supplier_name, mds.supplier_name) AS supplier_name,
    COALESCE(dyn.supplier_id, mds.supplier_id) AS supplier_id,
    COALESCE(dyn.supplier_company, mds.supplier_company) AS supplier_company,
    COALESCE(dyn.supplier_address, mds.supplier_address) AS supplier_address,
    COALESCE(dyn.supplier_city, mds.supplier_city) AS supplier_city,
    COALESCE(dyn.supplier_zip_code, mds.supplier_zip_code) AS supplier_zip_code,
    COALESCE(dyn.supplier_affiliate, mds.supplier_affiliate) AS supplier_affiliate,
    COALESCE(dyn.supplier_country_code, mds.supplier_country_code) AS supplier_country_code,
    COALESCE(dyn.supplier_legal_number, mds.supplier_legal_number) AS supplier_legal_number,
    tr.valid_from,
    tr.valid_to,
    CASE
        WHEN tr.valid_to = CAST('2999-12-31 23:59:59.999999' AS DATETIME2(6)) THEN 1
        ELSE 0
    END AS is_current
FROM time_ranges tr

LEFT JOIN source_supplier dyn
    ON dyn.bkey_supplier = tr.bkey_supplier
    AND dyn.valid_from <= tr.valid_from 
    AND COALESCE(dyn.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
    AND dyn.bkey_source = 'DYNAMICS'
     -- add only the source specific bkey's

LEFT JOIN source_supplier mds
    ON mds.bkey_supplier = tr.bkey_supplier
    AND mds.valid_from <= tr.valid_from 
    AND COALESCE(mds.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from
    AND mds.bkey_source = 'MDS' -- add only the source specific bkey's