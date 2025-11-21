CREATE                     PROCEDURE Test.sp_Upsert_ODS_with_Delete
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
    -- Step 3: Set ODSActive = 0 and ODSEndDate = NOW for Changed Rows
    ---------------------------------------------------
    SET @sql = N'
    UPDATE ods
    SET ods.ODSActive = 0,
        ods.ODSEndDate = CAST(GETDATE() AS DATE)
    FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ODSTableName) + ' ods
    INNER JOIN ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@StagingTableName) + ' stg
        ON stg.ODSKey = ods.ODSKey
    WHERE stg.ODSRecordStatus = ''C'' AND ods.ODSActive = 1;';
    EXEC sp_executesql @sql;


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

    
    -------------------------------
    -- Step 6: Mark as deleted when they dont exist in the source
    -------------------------------
    SET @sql = N'
    UPDATE ods
    SET 
        ODSDeleted = 1,
        ODSActive = 0,
        ODSEndDate = CAST(GETDATE() AS DATE)
    FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ODSTableName) + ' ods
    LEFT JOIN ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@StagingTableName) + ' stg
        ON ods.ODSKey = stg.ODSKey    
    WHERE stg.ODSKey IS NULL
    AND ods.ConsoID IN (
            SELECT distinct(vconso.[ConsoID])
            FROM [OSS_MonaConso_MHQ_Warehouse].[MonaOnPrem].[V_CONSO__ODS] vconso
            WHERE (
                        -- Case 1: This month (always valid)
                        (vconso.ConsoYear = YEAR(GETDATE()) 
                        AND vconso.ConsoMonth = MONTH(GETDATE()))
                        
                        -- Case 2: Last month, same year (Feb–Dec)
                        OR (vconso.ConsoYear = YEAR(GETDATE()) 
                            AND vconso.ConsoMonth = MONTH(GETDATE()) - 1
                            AND MONTH(GETDATE()) > 1)
                        
                        -- Case 3: January → include December of previous year
                        OR (vconso.ConsoYear = YEAR(DATEADD(MONTH, -1, GETDATE()))
                            AND vconso.ConsoMonth = MONTH(DATEADD(MONTH, -1, GETDATE())))
                    )
                    )
    AND ods.ODSActive = 1
    AND ods.ODSDeleted = 0;';
    EXEC sp_executesql @sql;

    ----------------------------------
    -- Step 7: Insert N and C records
    ----------------------------------
    SET @sql = N'
    INSERT INTO ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ODSTableName) + '
    SELECT *
    FROM ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@StagingTableName) + '
    WHERE ODSRecordStatus IN (''N'', ''C'');';
    EXEC sp_executesql @sql;
    -- check rowcount of N and C as a return of this sql query

END;