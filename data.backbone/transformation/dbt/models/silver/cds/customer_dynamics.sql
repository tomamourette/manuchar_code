-- ===============================
-- STEP 1: Extracting Historical Data (SCD2)
-- Generating valid_from and valid_to using modifieddate
-- ===============================

WITH dynamics_customer_custtable_history AS (
    SELECT 
        CONCAT(UPPER(dct.dataareaid), '_', dct.accountnum) + '_DYNAMICS' AS bkey_customer_source,
        CONCAT(UPPER(dct.dataareaid), '_', dct.accountnum) AS bkey_customer,
        'DYNAMICS' AS bkey_source,
        dct.custgroup,
        CASE 
            WHEN ROW_NUMBER() OVER (PARTITION BY CONCAT(UPPER(dct.dataareaid), '_', dct.accountnum) ORDER BY dct.modifiedon) = 1 
            THEN CAST('1900-01-01 00:00:00.000000' AS DATETIME2(6)) 
            ELSE CAST(dct.modifiedon AS DATETIME2(6)) 
        END AS valid_from,
        CAST(
            LEAD(dct.modifiedon) OVER (
                PARTITION BY CONCAT(UPPER(dct.dataareaid), '_', dct.accountnum)
                ORDER BY dct.modifiedon
            ) AS DATETIME2(6)
        ) AS valid_to
    FROM {{ ref("sv_dynamics_custtable") }} dct
),

-- ===============================
-- STEP 2: Generate Time Ranges for SCD2
-- Consolidating timestamps across history sources to create a unified timeline
-- ===============================
timeranges AS (
    SELECT 
        bkey_customer_source,
        bkey_customer,
        bkey_source, 
        valid_from,
        CAST(
            COALESCE(
                LEAD(valid_from) OVER (PARTITION BY bkey_customer ORDER BY valid_from),
                '2999-12-31 23:59:59.999999'
            ) AS DATETIME2(6)
        ) AS valid_to
    FROM dynamics_customer_custtable_history
),

-- ===============================
-- STEP 3: Extracting Current Data (SCD1)
-- Only Latest Record per Entity is Kept
-- ===============================

dynamics_customer_custtable_current AS (
    -- Entity attributes where only the latest version is relevant (SCD1)
    SELECT 
        *
    FROM (
        SELECT 
            CONCAT(UPPER(dct.dataareaid), '_', dct.accountnum) + '_DYNAMICS' AS bkey_customer_source,
            CONCAT(UPPER(dct.dataareaid), '_', dct.accountnum) AS bkey_customer,
            'DYNAMICS' AS bkey_source,
            dct.accountnum,
            dct.dataareaid,
            dct.vatnum,
            dct.lineofbusinessid,
            ROW_NUMBER() OVER (PARTITION BY CONCAT(dct.dataareaid, ' - ', dct.accountnum) ORDER BY dct.modifiedon DESC) AS rn
        FROM {{ ref("sv_dynamics_custtable") }} dct
    ) latest_values
    WHERE rn = 1
),

dynamics_customer_custgroup_current AS (
    SELECT 
        *
    FROM (
        SELECT 
            CONCAT(UPPER(dct.dataareaid), '_', dct.accountnum) + '_DYNAMICS' AS bkey_customer_source,
            CONCAT(UPPER(dct.dataareaid), '_', dct.accountnum) AS bkey_customer,
            'DYNAMICS' AS bkey_source,
            dcg.name, 
            ROW_NUMBER() OVER (PARTITION BY CONCAT(UPPER(dct.dataareaid), '_', dct.accountnum) ORDER BY dcg.modifieddatetime DESC) AS rn
        FROM {{ ref("sv_dynamics_custtable") }} dct
        LEFT JOIN {{ ref("sv_dynamics_custgroup") }} dcg ON dct.custgroup = dcg.custgroup
    ) AS sub
    WHERE rn = 1
),


dynamics_customer_party_current AS (
    -- Entity attributes where only the latest version is relevant (SCD1)
    SELECT 
        *
    FROM (
        SELECT 
            CONCAT(UPPER(dct.dataareaid), '_', dct.accountnum) + '_DYNAMICS' AS bkey_customer_source,
            CONCAT(UPPER(dct.dataareaid), '_', dct.accountnum) AS bkey_customer,
            'DYNAMICS' AS bkey_source,
            ddpt.name,
            ROW_NUMBER() OVER (PARTITION BY CONCAT(dct.dataareaid, ' - ', dct.accountnum) ORDER BY ddpt.modifiedon DESC) AS rn
        FROM {{ ref("sv_dynamics_custtable") }} dct
        LEFT OUTER JOIN {{ ref("sv_dynamics_dirpartytable") }} ddpt ON ddpt.recid = dct.party
    ) latest_values
    WHERE rn = 1
),

dynamics_customer_postal_address_current AS (
    -- Entity attributes where only the latest version is relevant (SCD1)
    SELECT 
        *
    FROM (
        SELECT 
	        CONCAT(UPPER(dct.dataareaid), '_', dct.accountnum) + '_DYNAMICS' AS bkey_customer_source,
            CONCAT(UPPER(dct.dataareaid), '_', dct.accountnum) AS bkey_customer,
            'DYNAMICS' AS bkey_source,
	        dlpa.countryregionid,
            dlpa.address,
	        dlpa.city,
            dlpa.zipcode,
            ROW_NUMBER() OVER (PARTITION BY CONCAT(dct.dataareaid, ' - ', dct.accountnum) ORDER BY dlpa.modifiedon DESC) AS rn
        FROM {{ ref("sv_dynamics_custtable") }} dct
        LEFT OUTER JOIN {{ ref("sv_dynamics_dirpartytable") }} ddpt ON ddpt.recid = dct.party
        LEFT OUTER JOIN {{ ref("sv_dynamics_dirpartylocation") }} ddpl ON ddpl.party = ddpt.recid AND ddpl.isprimary = 1
        LEFT OUTER JOIN {{ ref("sv_dynamics_logisticslocation") }} dll ON dll.recid = ddpl.location
        LEFT OUTER JOIN {{ ref("sv_dynamics_logisticspostaladdress") }} dlpa ON dlpa.location = dll.recid AND GETDATE() BETWEEN dlpa.validfrom AND dlpa.validto
    ) latest_values
    WHERE rn = 1
)

-- ===============================
-- STEP 4: Combine Everything into a Full Entity Timeline
-- - SCD2 (history tables) are joined on ID + valid time range.
-- - SCD1 (current tables) are joined on ID only.
-- ===============================

SELECT 
    tr.bkey_customer_source,
    tr.bkey_customer,
    tr.bkey_source,
    CONCAT(ec3.countryregionid, '_', ec1.vatnum) AS bkey_customer_global,
    UPPER(ec1.dataareaid) AS customer_company,  
    ec1.accountnum AS customer_id,
    ec2.name AS customer_name, 
    ec3.address AS customer_address, 
    ec1.vatnum AS customer_legal_number, 
    ec3.city AS customer_city,  
    ec3.zipcode AS customer_zip_code, 
    e1.custgroup AS customer_group, 
    ec4.name AS customer_group_description,
    ec1.lineofbusinessid AS customer_industry,  
    NULL AS customer_multinational_legal_number,  
    NULL AS customer_multinational_name, 
    NULL AS customer_gkam,  
    CASE WHEN e1.custgroup LIKE '%ICO%' THEN 1 ELSE 0 END AS customer_affiliate,
    ec3.countryregionid AS customer_country_code, 
  
    -- Metadata for time tracking
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

LEFT JOIN dynamics_customer_custtable_history e1 
ON e1.bkey_customer_source = tr.bkey_customer_source
AND e1.valid_from <= tr.valid_from 
AND COALESCE(e1.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from

-- ===============================
-- JOIN SCD1 (Current) TABLE ON ID ONLY (1-to-1 Relationship)
-- Since these values do not change over time, we only keep the latest version.
-- ===============================

LEFT JOIN dynamics_customer_custtable_current ec1
ON ec1.bkey_customer_source = tr.bkey_customer_source
  
LEFT JOIN dynamics_customer_party_current ec2
ON ec2.bkey_customer_source = tr.bkey_customer_source

LEFT JOIN dynamics_customer_postal_address_current ec3
ON ec3.bkey_customer_source = tr.bkey_customer_source

LEFT JOIN dynamics_customer_custgroup_current ec4
ON ec4.bkey_customer_source = tr.bkey_customer_source

