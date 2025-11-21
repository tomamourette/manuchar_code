

CREATE PROCEDURE [03DataSys].[SP_Update_DataProcess_Run](
    @DataProc_Run_Id INT,
    @DataProc_Id INT,
    @DataProc_Context VARCHAR(255),
    @DataProc_Run_Status VARCHAR(50),
    @DataProc_Run_DateStart DATETIME,
    @DataProc_Run_DateEnd DATETIME,
    @Run_NonCompletenessCheckCount INT,
    @DataProc_Run_Output VARCHAR(50),
    @UpdateBy VARCHAR(50)
)
AS
BEGIN
    -- Check if the record exists
    IF EXISTS (
        SELECT 1 
        FROM [03DataSys].Log_DataProcess_Run 
        WHERE DataProc_Run_Id = @DataProc_Run_Id
    )
    BEGIN
        -- Update the existing record
        UPDATE [03DataSys].Log_DataProcess_Run
        SET 
            DataProc_Id = @DataProc_Id,
            DataProc_Context = @DataProc_Context,
            DataProc_Run_Status = @DataProc_Run_Status,
            DataProc_Run_DateStart = @DataProc_Run_DateStart,
            DataProc_Run_DateEnd = @DataProc_Run_DateEnd,
            DataProc_Run_DurationSec = DATEDIFF(SECOND, @DataProc_Run_DateStart, @DataProc_Run_DateEnd),
            Run_NonCompletenessCheckCount = @Run_NonCompletenessCheckCount,
            DataProc_Run_Output = @DataProc_Run_Output,
            UpdateDate = GETDATE(),
            UpdateBy = @UpdateBy
        WHERE DataProc_Run_Id = @DataProc_Run_Id;
    END
    ELSE
    BEGIN
        -- Insert a new record
        INSERT INTO [03DataSys].Log_DataProcess_Run(
            DataProc_Run_Id, 
            DataProc_Id, 
            DataProc_Context, 
            DataProc_Run_Status, 
            DataProc_Run_DateStart, 
            Run_NonCompletenessCheckCount, 
            DataProc_Run_Output, 
            UpdateDate, 
            UpdateBy
        )
        VALUES (
            @DataProc_Run_Id,
            @DataProc_Id, 
            @DataProc_Context,
            @DataProc_Run_Status,
            @DataProc_Run_DateStart,
            @Run_NonCompletenessCheckCount,
            @DataProc_Run_Output,
            GETDATE(),
            @UpdateBy
        );
    END
END

GO

