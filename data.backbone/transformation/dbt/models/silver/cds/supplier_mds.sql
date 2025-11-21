-- ===============================
-- STEP 1: Extracting Historical Data (SCD2)
-- Generating valid_from and valid_to using modifieddatetime
-- ===============================

WITH mds_businesspartnercompanies_history AS (
    -- Track changes in BusinessPartnerCompanies
    SELECT
        bpc.Company_Code + '_' + UPPER(TRIM(bpc.Local_ID)) + '_MDS' AS bkey_supplier_source,
        bpc.Company_Code + '_' + UPPER(TRIM(bpc.Local_ID)) AS bkey_supplier,
        'MDS' AS bkey_source,
        bp.Is_Intercompany_Code AS supplier_affiliate,
        CASE 
            WHEN ROW_NUMBER() OVER (
                    PARTITION BY bpc.Company_Code + '_' + UPPER(TRIM(bpc.Local_ID)) 
                    ORDER BY bpc.LastChgDateTime
                ) = 1 
            THEN CAST('1900-01-01' AS DATETIME2(6))
            ELSE CAST(bpc.LastChgDateTime AS DATETIME2(6))
        END AS valid_from,
        LEAD(CAST(bpc.LastChgDateTime AS DATETIME2(6))) OVER (
            PARTITION BY bpc.Company_Code + '_' + UPPER(TRIM(bpc.Local_ID)) 
            ORDER BY bpc.LastChgDateTime
        ) AS valid_to
    FROM {{ ref('sv_mds_businesspartnercompanies') }} bpc
    LEFT JOIN {{ ref('sv_mds_businesspartner') }} bp 
        ON bp.Code = bpc.Business_Partner_Code
    WHERE bpc.[Type] = 'Supplier'
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
        CAST(valid_from AS DATETIME2(6)) AS valid_from,
        CAST(COALESCE(LEAD(valid_from) OVER (PARTITION BY bkey_supplier ORDER BY valid_from),'2999-12-31 23:59:59.999999') AS DATETIME2(6)) AS valid_to
    FROM (
        SELECT bkey_supplier_source, bkey_supplier, bkey_source, valid_from, valid_to FROM mds_businesspartnercompanies_history
    ) AS time_events
),

-- ===============================
-- STEP 3: Extracting Current Data (SCD1)
-- Only Latest Record per Supplier is Kept for Address Details
-- ===============================

mds_businesspartnercompanies_current AS (
    SELECT 
        bkey_supplier_source,
        bkey_supplier,
        bkey_source,
        supplier_name,
        supplier_company,
        supplier_id,
        supplier_address,
        supplier_city,
        supplier_country_code,
        supplier_zip_code,
        supplier_legal_number
    FROM (
        SELECT 
            bpc.Company_Code + '_' + UPPER(TRIM(bpc.Local_ID)) + '_MDS' AS bkey_supplier_source,
            bpc.Company_Code + '_' + UPPER(TRIM(bpc.Local_ID)) AS bkey_supplier,
            'MDS' AS bkey_source,
            bpc.Name AS supplier_name,
            bpc.Company_Code AS supplier_company,
            UPPER(TRIM(bpc.Local_ID)) AS supplier_id,
            bpc.Address AS supplier_address,
            bpc.City AS supplier_city,
            bpc.ZIP_Code AS supplier_zip_code,
            cou.ISO_Alpha_3_Code AS supplier_country_code,
            bpc.Legal_Number_Cleansed AS supplier_legal_number,
            ROW_NUMBER() OVER (PARTITION BY bpc.Company_Code + '_' + UPPER(TRIM(bpc.Local_ID)) ORDER BY bpc.LastChgDateTime DESC) AS rn
        FROM {{ ref('sv_mds_businesspartnercompanies') }} bpc
        LEFT JOIN {{ ref('sv_mds_businesspartner') }} bp ON bp.Code = bpc.Business_Partner_Code
        LEFT JOIN {{ ref('sv_mds_countries')}} cou ON bpc.Country_Code = cou.Code
        WHERE bpc.[Type] = 'Supplier' 
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
    CONCAT(bpcc.supplier_country_code, '_', bpcc.supplier_legal_number) AS bkey_supplier_global,
    CONVERT(VARCHAR, NULL) AS supplier_group,
    CONVERT(VARCHAR, NULL) AS supplier_group_description,
    bpcc.supplier_name,
    bpcc.supplier_company,
    bpcc.supplier_id,
    bpcc.supplier_address,  
    bpcc.supplier_city,  
    bpcc.supplier_zip_code,
    bpcc.supplier_country_code,
    bpch.supplier_affiliate,
    bpcc.supplier_legal_number,
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
LEFT JOIN mds_businesspartnercompanies_history bpch
ON bpch.bkey_supplier_source = tr.bkey_supplier_source
AND bpch.valid_from <= tr.valid_from 
AND COALESCE(bpch.valid_to, '2999-12-31 23:59:59.999999') > tr.valid_from

LEFT JOIN mds_businesspartnercompanies_current bpcc
ON bpcc.bkey_supplier_source = tr.bkey_supplier_source