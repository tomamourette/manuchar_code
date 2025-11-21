-- Step 1: Define the stored procedure with a parameter for the table name.
-- Step 2: Use dynamic SQL to construct the DELETE command instead of TRUNCATE.
-- Step 3: Execute the dynamic SQL command to delete all rows from the specified table.
-- Step 4: Handle potential errors that may arise during execution.

CREATE PROCEDURE [DataSys].[sp_TruncateTable]
    @TableName NVARCHAR(128) -- Parameter to receive the table name
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX); -- Variable to hold the dynamic SQL command

    -- Step 2: Construct the DELETE command
    SET @SQL = N'Truncate table ' + @TableName; 

    -- Step 3: Execute the dynamic SQL command
    EXEC sp_executesql @SQL; 
   
END;