-- ===============================
-- STEP 1: Extracting Historical Data (SCD2)
-- Generating valid_from and valid_to using modifieddate
-- ===============================

WITH mds_customer_golden_key_history AS (
    SELECT
        CONCAT(UPPER(mctm.Company_Name_Code), '_', mctm.Customer_ID) + '_MDS' AS bkey_customer_source,
        CONCAT(UPPER(mctm.Company_Name_Code), '_', mctm.Customer_ID) AS bkey_customer,
        'MDS' AS bkey_source,
        mcgk.Multinational_Customer_Name,
        mcgk.Affiliate_Code,
        CASE 
            WHEN ROW_NUMBER() OVER (PARTITION BY CONCAT(UPPER(mctm.Company_Name_Code), '_', mctm.Customer_ID) ORDER BY mcgk.EnterDateTime) = 1 
            THEN CAST('1900-01-01 00:00:00.000000' AS DATETIME2(6)) 
            ELSE CAST(mcgk.EnterDateTime AS DATETIME2(6)) 
        END AS valid_from,
        CAST(
            LEAD(mcgk.EnterDateTime) OVER (
                PARTITION BY CONCAT(UPPER(mctm.Company_Name_Code), '_', mctm.Customer_ID) 
                ORDER BY mcgk.EnterDateTime
            ) AS DATETIME2(6)
        ) AS valid_to
    FROM {{ ref("sv_mds_customergoldenkey") }} mcgk
    LEFT JOIN {{ ref("sv_mds_customermapping") }} mcm ON mcm.Customer_Golden_Key_Code = mcgk.Code
    LEFT JOIN {{ ref("sv_mds_customertomap") }} mctm ON mctm.Code = mcm.Customer_To_Map_Code
),

mds_customer_golden_key_2_history AS (
    SELECT
        CONCAT(UPPER(mctm.Company_Name_Code), '_', mctm.Customer_ID) + '_MDS' AS bkey_customer_source,
        CONCAT(UPPER(mctm.Company_Name_Code), '_', mctm.Customer_ID) AS bkey_customer,
        'MDS' AS bkey_source,
        mcgk2.Legal_Number,
        CASE 
            WHEN ROW_NUMBER() OVER (PARTITION BY CONCAT(UPPER(mctm.Company_Name_Code), '_', mctm.Customer_ID) ORDER BY mcgk2.EnterDateTime) = 1 
            THEN CAST('1900-01-01 00:00:00.000000' AS DATETIME2(6)) 
            ELSE CAST(mcgk2.EnterDateTime AS DATETIME2(6)) 
        END AS valid_from,
        CAST(
            LEAD(mcgk2.EnterDateTime) OVER (
                PARTITION BY CONCAT(UPPER(mctm.Company_Name_Code), '_', mctm.Customer_ID) 
                ORDER BY mcgk2.EnterDateTime
            ) AS DATETIME2(6)
        ) AS valid_to
    FROM {{ ref("sv_mds_customergoldenkey") }} mcgk
    LEFT JOIN {{ ref("sv_mds_customermapping") }} mcm ON mcm.Customer_Golden_Key_Code = mcgk.Code
    LEFT JOIN {{ ref("sv_mds_customertomap") }} mctm ON mctm.Code = mcm.Customer_To_Map_Code
    LEFT JOIN {{ ref("sv_mds_customergoldenkey") }} mcgk2 ON mcgk2.ID = mcgk.Multinational_Customer_ID
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
    FROM (
        SELECT bkey_customer_source, bkey_customer, bkey_source, valid_from FROM mds_customer_golden_key_history
        UNION
        SELECT bkey_customer_source, bkey_customer, bkey_source, valid_from FROM mds_customer_golden_key_2_history
    ) AS combined
),

-- ===============================
-- STEP 3: Extracting Current Data (SCD1)
-- Only Latest Record per Entity is Kept
-- ===============================

mds_customer_golden_key_current AS (
    -- Entity attributes where only the latest version is relevant (SCD1)
    SELECT 
        *
    FROM (
        SELECT 
            CONCAT(UPPER(mctm.Company_Name_Code), '_', mctm.Customer_ID) + '_MDS' AS bkey_customer_source,
            CONCAT(UPPER(mctm.Company_Name_Code), '_', mctm.Customer_ID) AS bkey_customer,
            'MDS' AS bkey_source,
            mcgk.Legal_Number,
            mcgk.Name,
            mcgk.Address,
            mcgk.City,
            mcgk.ZIPCode,
            mcgk.Industry_Type_Code,
            ROW_NUMBER() OVER (PARTITION BY CONCAT(UPPER(mctm.Company_Name_Code), ' - ', mctm.Customer_ID) ORDER BY mcgk.EnterDateTime DESC) AS rn
        FROM {{ ref("sv_mds_customergoldenkey") }} mcgk
        LEFT JOIN {{ ref("sv_mds_customermapping") }} mcm ON mcm.Customer_Golden_Key_Code = mcgk.Code
        LEFT JOIN {{ ref("sv_mds_customertomap") }} mctm ON mctm.Code = mcm.Customer_To_Map_Code
    ) latest_values
    WHERE rn = 1
),

mds_customer_to_map_current AS (
    -- Entity attributes where only the latest version is relevant (SCD1)
    SELECT 
        *
    FROM (
        SELECT 
            CONCAT(UPPER(mctm.Company_Name_Code), '_', mctm.Customer_ID) + '_MDS' AS bkey_customer_source,
            CONCAT(UPPER(mctm.Company_Name_Code), '_', mctm.Customer_ID) AS bkey_customer,
            'MDS' AS bkey_source,
            mctm.Customer_ID,
            mctm.Company_Name_Code,
            ROW_NUMBER() OVER (PARTITION BY CONCAT(UPPER(mctm.Company_Name_Code), ' - ', mctm.Customer_ID) ORDER BY mctm.EnterDateTime DESC) AS rn
        FROM {{ ref("sv_mds_customergoldenkey") }} mcgk
        LEFT JOIN {{ ref("sv_mds_customermapping") }} mcm ON mcm.Customer_Golden_Key_Code = mcgk.Code
        LEFT JOIN {{ ref("sv_mds_customertomap") }} mctm ON mctm.Code = mcm.Customer_To_Map_Code
    ) latest_values
    WHERE rn = 1
),

mds_customer_country_current AS (
    -- Entity attributes where only the latest version is relevant (SCD1)
    SELECT 
        *
    FROM (
        SELECT 
            CONCAT(UPPER(mctm.Company_Name_Code), '_', mctm.Customer_ID) + '_MDS' AS bkey_customer_source,
            CONCAT(UPPER(mctm.Company_Name_Code), '_', mctm.Customer_ID) AS bkey_customer,
            'MDS' AS bkey_source,
            mco.ISO_Alpha_3_Code,
            ROW_NUMBER() OVER (PARTITION BY CONCAT(UPPER(mctm.Company_Name_Code), ' - ', mctm.Customer_ID) ORDER BY mco.EnterDateTime DESC) AS rn
        FROM {{ ref("sv_mds_customergoldenkey") }} mcgk
        LEFT JOIN {{ ref("sv_mds_customermapping") }} mcm ON mcm.Customer_Golden_Key_Code = mcgk.Code
        LEFT JOIN {{ ref("sv_mds_customertomap") }} mctm ON mctm.Code = mcm.Customer_To_Map_Code
	    LEFT JOIN {{ ref("sv_mds_countries") }} mco ON mco.Code = mctm.Country_Code_Code
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
    CONCAT(ec3.ISO_Alpha_3_Code, '_', ec1.Legal_Number) AS bkey_customer_global,
    ec2.Company_Name_Code AS customer_company,  
    ec2.Customer_ID AS customer_id,
    ec1.Name AS customer_name, 
    ec1.Address AS customer_address, 
    ec1.Legal_Number AS customer_legal_number, 
    ec1.City AS customer_city,  
    ec1.ZIPCode AS customer_zip_code, 
    NULL AS customer_group,
    NULL AS customer_group_description, 
    ec1.Industry_Type_Code AS customer_industry,  
    e2.Legal_Number AS customer_multinational_legal_number,  
    e1.Multinational_Customer_Name AS customer_multinational_name, 
    NULL AS customer_gkam,  
    e1.Affiliate_Code AS customer_affiliate,
    ec3.ISO_Alpha_3_Code AS customer_country_code, 

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

LEFT JOIN mds_customer_golden_key_history e1 
ON e1.bkey_customer_source = tr.bkey_customer_source
AND e1.valid_from <= tr.valid_from 
AND COALESCE(e1.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from

LEFT JOIN mds_customer_golden_key_2_history e2 
ON e2.bkey_customer_source = tr.bkey_customer_source
AND e2.valid_from <= tr.valid_from 
AND COALESCE(e2.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from

-- ===============================
-- JOIN SCD1 (Current) TABLE ON ID ONLY (1-to-1 Relationship)
-- Since these values do not change over time, we only keep the latest version.
-- ===============================

LEFT JOIN mds_customer_golden_key_current ec1
ON ec1.bkey_customer_source = tr.bkey_customer_source
  
LEFT JOIN mds_customer_to_map_current ec2
ON ec2.bkey_customer_source = tr.bkey_customer_source
  
LEFT JOIN mds_customer_country_current ec3
ON ec3.bkey_customer_source = tr.bkey_customer_source