CREATE PROCEDURE UpdateAndInsertCustomerData
AS
BEGIN
    -- Create ODS_hash CTE
    WITH ODS_hash AS (
        SELECT 
            CONCAT(UPPER(ctm.Company_Name_Code), ' - ', ctm.Customer_ID) AS customer_local_bk,
            CONCAT(co.ISO_Alpha_3_Code, ' - ', cgk.Legal_Number) AS customer_global_bk,
            CAST(ctm.Customer_ID AS VARCHAR(500)) AS customer_local_id,
            UPPER(ctm.Company_Name_Code) AS customer_company_code,
            cgk.Name AS customer_name,
            cgk.Address AS customer_address,
            cgk.Legal_Number AS customer_legal_number,
            cgk.City AS customer_city,
            cgk.ZIP_Code AS customer_zip_code,
            co.ISO_Alpha_3_Code AS customer_country,
            NULL AS customer_group,
            cgk.Industry_Type_Code AS customer_industry,
            NULL AS gkam,
            cgk.Multinational_Customer_Name AS multinational_name,
            COALESCE(cgk2.Legal_Number, NULL) AS multinational_legal_number,
            CASE WHEN cgk.Affiliate_Code = '1' THEN 1 ELSE 0 END AS affiliate,
            'MDS' AS source,
            HASHBYTES('MD5', CONCAT_WS('|', 
                cgk.Name, cgk.Address, cgk.Legal_Number, cgk.City, 
                cgk.ZIP_Code, co.ISO_Alpha_3_Code, cgk.Industry_Type_Code, 
                cgk.Multinational_Customer_Name, cgk2.Legal_Number, cgk.Affiliate_Code
            )) AS CDSHashValue
        FROM [30MDS_ods].mdm__Customer_Golden_Key cgk
        LEFT JOIN [30MDS_ods].mdm__Customer_Golden_Key cgk2 ON cgk2.ID = cgk.Multinational_Customer_ID
        LEFT JOIN [30MDS_ods].mdm__Customer_Mapping cm ON cm.Customer_Golden_Key_Code = cgk.Code
        LEFT JOIN [30MDS_ods].mdm__Customer_To_Map ctm ON ctm.Code = cm.Customer_To_Map_Code
        LEFT JOIN [30MDS_ods].mdm__Countries co ON co.Code = ctm.Country_Code_Code    
    ),
    -- Create ODS CTE
    ODS AS (    
        SELECT 
            ods.customer_local_bk, 
            ods.CDSHashValue,
            cds.customer_local_bk AS cds_customer_local_bk,
            cds.CDSHashValue AS cds_CDSHashValue,
            CASE
                WHEN cds.customer_local_bk IS NULL
                    THEN 'N'
                WHEN cds.customer_local_bk = ods.customer_local_bk AND cds.CDSHashValue <> ods.CDSHashValue
                    THEN 'C'
                ELSE 'S'
            END AS CDSRecordStatus
        FROM ODS_hash ods
        LEFT JOIN [30MDS_cds].Customer cds ON cds.customer_local_bk = ods.customer_local_bk
    )
    
    -- Update CDS Fields for Changed Records
    UPDATE CDS
       SET CDS.[CDSEndDate] = GETUTCDATE(),
           CDS.[CDSActive] = CONVERT(BIT, 0)
       FROM [30MDS_cds].Customer CDS 
       INNER JOIN ODS ON CDS.customer_local_bk = ODS.customer_local_bk
       WHERE ODS.[CDSRecordStatus] = 'C'
           AND CDS.[CDSEndDate] = CONVERT(DATETIME, '31-12-9999', 103)
           AND CDS.[CDSActive] = CONVERT(BIT, 1);

    -- Insert New And Changed Records into CDS Table
    INSERT INTO [30MDS_cds].Customer (
        customer_local_bk, customer_global_bk, customer_local_id, customer_company_code, 
        customer_name, customer_address, customer_legal_number, customer_city, customer_zip_code, 
        customer_country, customer_group, customer_industry, gkam, multinational_name, 
        multinational_legal_number, affiliate, source, CDSStartDate, CDSEndDate, CDSActive, CDSHashValue
    )
    SELECT 
        ods.customer_local_bk, ods.customer_global_bk, ods.customer_local_id, ods.customer_company_code, 
        ods.customer_name, ods.customer_address, ods.customer_legal_number, ods.customer_city, ods.customer_zip_code, 
        ods.customer_country, ods.customer_group, ods.customer_industry, ods.gkam, ods.multinational_name, 
        ods.multinational_legal_number, ods.affiliate, ods.source, 
        GETUTCDATE() AS CDSStartDate,
        CONVERT(DATETIME, '31-12-9999', 103) AS CDSEndDate,
        CONVERT(BIT, 1) AS CDSActive,
        ods.CDSHashValue
    FROM ODS ods
    WHERE ODSRecordStatus IN ('C', 'N');
END

GO

