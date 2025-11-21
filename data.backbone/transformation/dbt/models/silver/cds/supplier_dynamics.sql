-- ===============================
-- STEP 1: Extracting Historical Data (SCD2)
-- Generating valid_from and valid_to using modifieddatetime
-- ===============================

WITH dynamics_vendtable_history AS (
    SELECT 
        CONCAT(UPPER(vt.dataareaid), '_', vt.accountnum) + '_DYNAMICS' AS bkey_supplier_source,
        CONCAT(UPPER(vt.dataareaid), '_', vt.accountnum) AS bkey_supplier,
        'DYNAMICS' AS bkey_source,
        vt.vendgroup,
        CASE 
            WHEN ROW_NUMBER() OVER (PARTITION BY CONCAT(UPPER(vt.dataareaid), '_', vt.accountnum) ORDER BY vt.modifieddatetime) = 1 
            THEN CAST('1900-01-01 00:00:00.000000' AS DATETIME2(6))
            ELSE CAST(vt.modifieddatetime AS DATETIME2(6))
        END AS valid_from,
        CAST(
            LEAD(vt.modifieddatetime) OVER (
                PARTITION BY CONCAT(UPPER(vt.dataareaid), '_', vt.accountnum) 
                ORDER BY vt.modifieddatetime
            ) AS DATETIME2(6)
        ) AS valid_to
    FROM {{ ref("sv_dynamics_vendtable") }} vt
),
-- ===============================
-- STEP 2: Generate Time Ranges for SCD2
-- Consolidating timestamps across history sources to create a unified timeline
-- Filter valid_to IS NOT NULL, because there are dates with NULL value in source
-- ===============================

timeranges AS (
    SELECT 
        bkey_supplier_source,
        bkey_supplier,
        bkey_source,
        valid_from,
        CAST(
            COALESCE(
                LEAD(valid_from) OVER (PARTITION BY bkey_supplier ORDER BY valid_from),
                '2999-12-31 23:59:59.999999'
            ) AS DATETIME2(6)
        ) AS valid_to
    FROM dynamics_vendtable_history
),

-- ===============================
-- STEP 3: Extracting Current Data (SCD1)
-- Only Latest Record per Supplier is Kept for Address Details
-- ===============================

dynamics_vendtable_current AS (
    SELECT 
        *
    FROM (
        SELECT 
            CONCAT(UPPER(vt.dataareaid), '_', vt.accountnum) + '_DYNAMICS' AS bkey_supplier_source,
            CONCAT(UPPER(vt.dataareaid), '_', vt.accountnum) AS bkey_supplier,
            'DYNAMICS' AS bkey_source,
            UPPER(vt.dataareaid) AS dataareaid, 
            vt.accountnum,
            vt.vatnum, 
            ROW_NUMBER() OVER (PARTITION BY CONCAT(UPPER(vt.dataareaid), '_', vt.accountnum) ORDER BY vt.modifieddatetime DESC) AS rn
        FROM {{ ref("sv_dynamics_vendtable") }} vt
    ) AS sub
    WHERE rn = 1
),

dynamics_vendgroup_current AS (
    SELECT 
        *
    FROM (
        SELECT 
            CONCAT(UPPER(vt.dataareaid), '_', vt.accountnum) + '_DYNAMICS' AS bkey_supplier_source,
            CONCAT(UPPER(vt.dataareaid), '_', vt.accountnum) AS bkey_supplier,
            'DYNAMICS' AS bkey_source,  
            vg.name, 
            ROW_NUMBER() OVER (PARTITION BY CONCAT(UPPER(vt.dataareaid), '_', vt.accountnum) ORDER BY vg.modifieddatetime DESC) AS rn
        FROM {{ ref("sv_dynamics_vendtable") }} vt
        LEFT JOIN {{ ref("sv_dynamics_vendgroup") }} vg ON vt.vendgroup = vg.vendgroup
    ) AS sub
    WHERE rn = 1
),

dynamics_dirparty_current AS (
    SELECT 
        *
    FROM (
        SELECT 
            CONCAT(UPPER(vt.dataareaid), '_', vt.accountnum) + '_DYNAMICS' AS bkey_supplier_source,
            CONCAT(UPPER(vt.dataareaid), '_', vt.accountnum) AS bkey_supplier,
            'DYNAMICS' AS bkey_source,
            dp.name,
            ROW_NUMBER() OVER (PARTITION BY CONCAT(UPPER(vt.dataareaid), '_', vt.accountnum) ORDER BY dp.createddatetime DESC) AS rn
        FROM {{ ref("sv_dynamics_vendtable") }} vt
        LEFT JOIN {{ ref("sv_dynamics_dirpartytable") }} dp ON vt.party = dp.recid
    ) AS sub
    WHERE rn = 1
),

dynamics_address_current AS (
    SELECT 
        *
    FROM (
        SELECT 
            CONCAT(UPPER(vt.dataareaid), '_', vt.accountnum) + '_DYNAMICS' AS bkey_supplier_source,
            CONCAT(UPPER(vt.dataareaid), '_', vt.accountnum) AS bkey_supplier,
            'DYNAMICS' AS bkey_source,
            lpa.location,
            lpa.street,
            lpa.city,
            lpa.zipcode,
            lpa.countryregionid,
            ROW_NUMBER() OVER (PARTITION BY CONCAT(UPPER(vt.dataareaid), '_', vt.accountnum) ORDER BY lpa.modifieddatetime DESC) AS rn
        FROM {{ ref("sv_dynamics_vendtable") }} vt
        LEFT JOIN {{ ref("sv_dynamics_dirpartytable") }} dp ON vt.party = dp.recid
        LEFT JOIN {{ ref("sv_dynamics_logisticspostaladdress") }} lpa ON dp.primaryaddresslocation = lpa.location
    ) AS sub
    WHERE rn = 1
)

-- ===============================
-- STEP 4: Combine Everything into a Full Supplier Timeline
-- - SCD2 (history tables) are joined on ID + valid time range.
-- - SCD1 (current tables) are joined on ID only.
-- ===============================

SELECT
    tr.bkey_supplier_source,
    tr.bkey_supplier,
    tr.bkey_source,
    CONCAT(ac.countryregionid, '_', vtc.vatnum) AS bkey_supplier_global,
    vth.vendgroup AS supplier_group,  
    vgc.name AS supplier_group_description,
    dpc.name AS supplier_name,  
    vtc.accountnum AS supplier_id,
    vtc.dataareaid AS supplier_company,
    ac.street AS supplier_address,  
    ac.city AS supplier_city,  
    ac.zipcode AS supplier_zip_code,
    CASE WHEN vth.vendgroup LIKE '%ICO%' THEN 1 ELSE 0 END AS supplier_affiliate,
    ac.countryregionid AS supplier_country_code,
    vtc.vatnum AS supplier_legal_number,
    tr.valid_from,
    tr.valid_to,
    CASE 
        WHEN tr.valid_to = '2999-12-31 23:59:59.999999' THEN 1 
        ELSE 0
    END AS is_current

FROM timeranges tr

-- ===============================
-- JOIN SCD2 (History) TABLES ON ID + TIME RANGE
-- Ensures correct historical version is retrieved based on the event timestamp.
-- ===============================
LEFT JOIN dynamics_vendtable_history vth
ON vth.bkey_supplier_source = tr.bkey_supplier_source
AND vth.valid_from <= tr.valid_from 
AND COALESCE(vth.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from

-- ===============================
-- JOIN SCD1 (Current) TABLE FOR ADDRESS (no time range needed)
-- ===============================
LEFT JOIN dynamics_vendtable_current vtc
ON vtc.bkey_supplier_source = tr.bkey_supplier_source

LEFT JOIN dynamics_vendgroup_current vgc
ON vgc.bkey_supplier_source = tr.bkey_supplier_source

LEFT JOIN dynamics_dirparty_current dpc
ON dpc.bkey_supplier_source = tr.bkey_supplier_source

LEFT JOIN dynamics_address_current ac
ON ac.bkey_supplier_source = tr.bkey_supplier_source
