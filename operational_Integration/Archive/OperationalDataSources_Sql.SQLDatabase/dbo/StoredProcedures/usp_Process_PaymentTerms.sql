
CREATE PROCEDURE usp_Process_PaymentTerms
AS
BEGIN
    SET NOCOUNT ON;

    -- Step 1: Ensure PaymentTerm table exists
    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PaymentTerm')
    BEGIN
        CREATE TABLE PaymentTerm (
            id INT IDENTITY(1,1),
            bk NVARCHAR(50) NOT NULL,
            paymenttermcode NVARCHAR(50) NOT NULL,
            paymenttermdescription NVARCHAR(255),
            numberofdays INT,
            startdate DATE NOT NULL,
            enddate DATE DEFAULT '9999-12-31',
            row_hash VARBINARY(32)
        );
    END;

    -- Step 2: Drop Temporary Table if Exists
    IF OBJECT_ID('tempdb..#FinalData') IS NOT NULL
        DROP TABLE #FinalData;

    CREATE TABLE #FinalData (
        bk NVARCHAR(50),
        paymenttermcode NVARCHAR(50),
        paymenttermdescription NVARCHAR(255),
        numberofdays INT,
        startdate DATE,
        enddate DATE, 
        row_hash VARBINARY(32)
    );

    -- Step 3: Extract Ordered Data for Initial and Incremental Loads
    WITH OrderedData AS (
        SELECT DISTINCT
            paymtermid AS bk,
            paymtermid AS paymenttermcode,          
            description AS paymenttermdescription,   
            numofdays AS numberofdays,
            createddatetime AS original_startdate,
            HASHBYTES('SHA2_256', CONCAT(description, '|', numofdays)) AS row_hash
        FROM [21D365_ods].paymterm
    ),
    -- Step 4: Rank Versions to Identify the First Record for Each `bk`
    RankedData AS (
        SELECT 
            o.*,
            ROW_NUMBER() OVER (PARTITION BY o.bk ORDER BY o.original_startdate) AS version_rank
        FROM OrderedData o
    ),
    -- Step 5: Get Latest Version of Each `bk`
    LatestHistory AS (
        SELECT h.*
        FROM PaymentTerm h
        WHERE h.enddate = '9999-12-31'
    ),
    VersionedData AS (
        SELECT 
            o.bk,
            o.paymenttermcode,          
            o.paymenttermdescription,   
            o.numberofdays,
            -- ✅ If it's the first version in ODS, use `createddatetime` from the source.
            -- ✅ Otherwise, use `GETDATE()` for incremental changes.
            CASE 
                WHEN h.row_hash IS NULL AND o.version_rank = 1 THEN o.original_startdate
                WHEN h.row_hash IS NULL THEN CAST(GETDATE() AS DATE)
                WHEN h.row_hash <> o.row_hash THEN CAST(GETDATE() AS DATE)  -- Incremental change detected
                ELSE h.startdate
            END AS startdate,
            o.row_hash
        FROM RankedData o
        LEFT JOIN LatestHistory h ON o.bk = h.bk
    )

    -- Step 6: Insert Processed Data into #FinalData, Including `enddate`
    INSERT INTO #FinalData (bk, paymenttermcode, paymenttermdescription, numberofdays, startdate, enddate, row_hash)
    SELECT 
        v.bk,
        v.paymenttermcode,          
        v.paymenttermdescription,   
        v.numberofdays,
        v.startdate,
        -- `enddate` should be the `startdate` of the next version or `9999-12-31`
        COALESCE(
            LEAD(v.startdate) OVER (PARTITION BY v.bk ORDER BY v.startdate), 
            CAST('9999-12-31' AS DATE)
        ) AS enddate,
        v.row_hash
    FROM VersionedData v;

    -- Step 7: Assign Correct `enddate` for Historical Versions
    UPDATE f1
    SET f1.enddate = (SELECT MIN(f2.startdate) FROM #FinalData f2 WHERE f1.bk = f2.bk AND f2.startdate > f1.startdate)
    FROM #FinalData f1
    WHERE f1.enddate IS NULL;

    -- Step 8: Set Default `enddate = 9999-12-31` If Still NULL
    UPDATE #FinalData
    SET enddate = '9999-12-31'
    WHERE enddate IS NULL;

    -- Step 9: Insert New or Changed Records into PaymentTerm
    INSERT INTO PaymentTerm (bk, paymenttermcode, paymenttermdescription, numberofdays, startdate, enddate, row_hash)
    SELECT 
        f.bk, f.paymenttermcode, f.paymenttermdescription, f.numberofdays, f.startdate, f.enddate, f.row_hash
    FROM #FinalData f
    LEFT JOIN PaymentTerm p ON f.bk = p.bk AND f.row_hash = p.row_hash
    WHERE p.bk IS NULL;

    -- Cleanup: Drop Temporary Table
    DROP TABLE #FinalData;
END;

GO

