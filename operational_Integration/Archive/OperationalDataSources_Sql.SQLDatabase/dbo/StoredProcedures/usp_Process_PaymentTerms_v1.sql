
CREATE PROCEDURE usp_Process_PaymentTerms_v1
AS
BEGIN
    SET NOCOUNT ON;

    -- Step 1: Ensure `PaymentTerms_v1` table exists WITHOUT a primary key
    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PaymentTerms_v1')
    BEGIN
        CREATE TABLE PaymentTerms_v1 (
            bk NVARCHAR(50) NOT NULL,
            paymenttermcode NVARCHAR(50) NOT NULL,
            paymenttermdescription NVARCHAR(255),
            numberofdays INT,
            startdate DATE NOT NULL,
            enddate DATE NOT NULL DEFAULT '9999-12-31',
            row_hash VARBINARY(32) NOT NULL
        );
    END;

    -- Step 2: Drop Temporary Table if Exists
    IF OBJECT_ID('tempdb..#ODS_Processed') IS NOT NULL
        DROP TABLE #ODS_Processed;

    -- Step 3: Create Temporary Table to Store Processed Data
    CREATE TABLE #ODS_Processed (
        bk NVARCHAR(50),
        paymenttermcode NVARCHAR(50),
        paymenttermdescription NVARCHAR(255),
        numberofdays INT,
        createdon DATE,
        row_hash VARBINARY(32),
        record_status CHAR(1)  -- 'N' = New, 'C' = Changed, 'S' = Same
    );

    -- Step 4: Extract Data from ODS, Remove Duplicates, and Compute Hashes
    INSERT INTO #ODS_Processed (bk, paymenttermcode, paymenttermdescription, numberofdays, createdon, row_hash, record_status)
    SELECT DISTINCT  -- ✅ Remove duplicate records from ODS before processing
        ODS.bk,
        ODS.paymenttermcode,          
        ODS.paymenttermdescription,   
        ODS.numberofdays,
        ODS.createdon,
        ODS.row_hash,
        CASE 
            WHEN P.bk IS NULL THEN 'N'  -- New record
            WHEN P.row_hash <> ODS.row_hash THEN 'C'  -- Changed record
            ELSE 'S'  -- Same record (no change)
        END AS record_status
    FROM (
        SELECT DISTINCT  -- ✅ Ensures only unique rows are extracted
            paymtermid AS bk,
            paymtermid AS paymenttermcode,          
            description AS paymenttermdescription,   
            numofdays AS numberofdays,
            createddatetime AS createdon,
            HASHBYTES('SHA2_256', CONCAT(description, '|', numofdays)) AS row_hash
        FROM [21D365_ods].paymterm
    ) ODS
    LEFT JOIN PaymentTerms_v1 P 
        ON ODS.bk = P.bk;

    -- Step 5: Update `enddate` for Changed Records
    UPDATE P
    SET P.enddate = GETDATE()
    FROM PaymentTerms_v1 P
    INNER JOIN #ODS_Processed O 
        ON P.bk = O.bk
    WHERE O.record_status = 'C'  -- Only update if record changed
      AND P.enddate = '9999-12-31';  -- Only update open records

    -- Step 6: Insert New and Changed Records with Different `startdate`
    INSERT INTO PaymentTerms_v1 (bk, paymenttermcode, paymenttermdescription, numberofdays, startdate, enddate, row_hash)
    SELECT 
        bk, paymenttermcode, paymenttermdescription, numberofdays,
        GETDATE() AS startdate,  -- New versions start today
        '9999-12-31' AS enddate, -- Open-ended until another change occurs
        row_hash
    FROM #ODS_Processed
    WHERE record_status IN ('N', 'C');  -- Only insert new or changed records

    -- Step 7: Drop Temporary Table
    DROP TABLE #ODS_Processed;

END;

GO

