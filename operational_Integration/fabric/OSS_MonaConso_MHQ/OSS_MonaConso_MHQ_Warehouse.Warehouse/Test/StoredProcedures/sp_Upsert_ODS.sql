CREATE                 PROCEDURE Test.sp_Upsert_ODS
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
    -------------------------------
    SET @sql = N'
    UPDATE stg
    SET ODSRecordStatus = ''C''
    FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@StagingTableName) + ' stg
    INNER JOIN ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ODSTableName) + ' ods
        ON stg.ODSKey = ods.ODSKey
    WHERE stg.ODSHash <> ods.ODSHash
    AND ods.ODSActive = 1
    AND ods.ODSDeleted = 0;';
    EXEC sp_executesql @sql;

    ---------------------------------------------------------
    -- Step 3: Update ODSVersion to max + 1 where changed
    ---------------------------------------------------------
    SET @sql = N'
    UPDATE stg
    SET ODSVersion = ods.ODSVersion + 1
    FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@StagingTableName) + ' stg
    INNER JOIN (
        SELECT o.ODSKey, MAX(o.ODSVersion) AS ODSVersion
        FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ODSTableName) + ' o
        GROUP BY o.ODSKey
    ) ods ON stg.ODSKey = ods.ODSKey
    WHERE stg.ODSRecordStatus = ''C''
    AND ods.ODSActive = 1
    AND ods.ODSDeleted = 0;';
    EXEC sp_executesql @sql;
    

    ---------------------------------------------------
    -- Step 4: Set ODSActive = 0 and ODSEndDate = NOW
    ---------------------------------------------------
    SET @sql = N'
    UPDATE ods
    SET ODSActive = 0,
        ODSEndDate = CAST(GETDATE() AS DATE)
    FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ODSTableName) + ' ods
    INNER JOIN ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@StagingTableName) + ' stg
        ON stg.ODSKey = ods.ODSKey
    WHERE stg.ODSRecordStatus = ''C'' AND ods.ODSActive = 1;';
    EXEC sp_executesql @sql;

    -------------------------------
    -- Step 5: Mark as (E)xisting
    -------------------------------
    SET @sql = N'
    UPDATE stg
    SET ODSRecordStatus = ''E''
    FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@StagingTableName) + ' stg
    INNER JOIN ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ODSTableName) + ' ods
        ON stg.ODSKey = ods.ODSKey
    WHERE stg.ODSHash = ods.ODSHash;';
    EXEC sp_executesql @sql;

    -------------------------------
    -- Step 6: Mark as deleted
    -------------------------------
    SET @sql = N'
    UPDATE ods
    SET ODSDeleted = 1,
        ODSActive = 0,
        ODSEndDate = CAST(GETDATE() AS DATE)
    FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ODSTableName) + ' ods
    LEFT JOIN ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@StagingTableName) + ' stg
        ON ods.ODSKey = stg.ODSKey
    WHERE stg.ODSKey IS NULL
    AND ods.ODSActive = 1
    AND (ods.ODSDeleted IS NULL OR ods.ODSDeleted = 0);';
    EXEC sp_executesql @sql;

    ----------------------------------
    -- Step 6: Insert N and C records
    ----------------------------------
    SET @sql = N'
    INSERT INTO ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ODSTableName) + '
    SELECT *
    FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@StagingTableName) + '
    WHERE ODSRecordStatus IN (''N'', ''C'');';
    EXEC sp_executesql @sql;
    -- check rowcount of N and C as a return of this sql query

END;