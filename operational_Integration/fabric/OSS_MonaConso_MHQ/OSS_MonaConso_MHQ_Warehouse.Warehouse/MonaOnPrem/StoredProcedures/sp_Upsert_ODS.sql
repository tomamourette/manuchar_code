CREATE                         PROCEDURE MonaOnPrem.sp_Upsert_ODS
    @StagingTableName NVARCHAR(128),  -- e.g., 'V_DATA_CONSO__STG'
    @ODSTableName NVARCHAR(128),      -- e.g., 'V_DATA_CONSO__ODS'
    @SchemaName NVARCHAR(128)        -- e.g., 'dbo'
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @sql NVARCHAR(MAX);
    DECLARE @ObjectFullName NVARCHAR(260);

    -- Construct full object name to check existence
    SET @ObjectFullName = @SchemaName + '.' + @ODSTableName;


    ----------------------------
    -- Step 1: Mark as (N)ew
    ----------------------------
    SET @sql = N'
    UPDATE stg
    SET ODSRecordStatus = ''N''
    FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@StagingTableName) + ' stg
    LEFT JOIN ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ODSTableName) + ' ods
        ON stg.ODSKey = ods.ODSKey 
    WHERE ods.ODSKey IS NULL;';
    EXEC sp_executesql @sql;

    -------------------------------
    -- Step 2: Mark as (C)hanged
    -- And update ODSVersion to max + 1 where changed
    -------------------------------
    SET @sql = N'
        UPDATE stg
        SET 
            stg.ODSRecordStatus = ''C'',
            stg.ODSVersion = ods.MaxODSVersion + 1
        FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@StagingTableName) + ' stg
        INNER JOIN (
            SELECT 
                o.ODSKey,
                o.ODSHash,
                o.ODSActive,
                o.ODSDeleted,
                MAX(o.ODSVersion) AS MaxODSVersion
            FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ODSTableName) + ' o
            WHERE o.ODSActive = 1
            AND o.ODSDeleted = 0
            GROUP BY o.ODSKey, o.ODSHash, o.ODSActive, o.ODSDeleted
        ) ods ON stg.ODSKey = ods.ODSKey
        WHERE stg.ODSHash <> ods.ODSHash
        ';

    EXEC sp_executesql @sql;

    ---------------------------------------------------
    -- Step 3: Only run if there are (C)hanged rows
    ---------------------------------------------------
    DECLARE @ChangedCount INT;

    -- Count changed rows in the staging table
    SET @sql = N'
        SELECT @ChangedCountOut = COUNT(*)
        FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@StagingTableName) + '
        WHERE ODSRecordStatus = ''C'';
    ';

    EXEC sp_executesql 
        @sql,
        N'@ChangedCountOut INT OUTPUT',
        @ChangedCountOut = @ChangedCount OUTPUT;

    -- If any changed rows exist, then update ODS
    IF @ChangedCount > 0
    BEGIN
        SET @sql = N'
            UPDATE ods
            SET ods.ODSActive = 0,
                ods.ODSEndDate = CAST(GETDATE() AS DATE)
            FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ODSTableName) + ' ods
            INNER JOIN ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@StagingTableName) + ' stg
                ON stg.ODSKey = ods.ODSKey
            WHERE stg.ODSRecordStatus = ''C'' AND ods.ODSActive = 1;
        ';
        EXEC sp_executesql @sql;
    END
    ELSE
    BEGIN
        PRINT 'No changed rows found — skipping Step 3.';
    END;

    -------------------------------
    -- Step 4: Mark as (E)xisting
    -------------------------------
    SET @sql = N'
    UPDATE stg
    SET stg.ODSRecordStatus = ''E''
    FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@StagingTableName) + ' stg
    INNER JOIN ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ODSTableName) + ' ods
        ON stg.ODSKey = ods.ODSKey
    WHERE stg.ODSHash = ods.ODSHash;';
    EXEC sp_executesql @sql;
END;