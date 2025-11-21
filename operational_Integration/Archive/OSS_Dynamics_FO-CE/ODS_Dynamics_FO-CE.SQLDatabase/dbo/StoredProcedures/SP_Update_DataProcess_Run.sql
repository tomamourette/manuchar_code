CREATE PROCEDURE SP_Update_DataProcess_Run(
    @DataProc_Run_Id INT,
    @DataProc_Id INT,
    @DataProc_Context VARCHAR(255),
    @DataProc_Run_Status VARCHAR(50),
    @DataProc_Run_DateStart DATETIME,
    @DataProc_Run_DateEnd DATETIME,
    @DataProc_Run_DurationSec INT,
    @Run_NonCompletenessCheckCount INT,
    @DataProc_Run_Output VARCHAR(50),
    @UpdateDate DATETIME,
    @UpdateBy VARCHAR(50)
)
AS
BEGIN
    -- Update the DataProcess_Run table with the provided parameters
    UPDATE DataProcess_Run
    SET 
        DataProc_Id = @DataProc_Id,
        DataProc_Context = @DataProc_Context,
        DataProc_Run_Status = @DataProc_Run_Status,
        DataProc_Run_DateStart = @DataProc_Run_DateStart,
        DataProc_Run_DateEnd = @DataProc_Run_DateEnd,
        DataProc_Run_DurationSec = @DataProc_Run_DurationSec,
        Run_NonCompletenessCheckCount = @Run_NonCompletenessCheckCount,
        DataProc_Run_Output = @DataProc_Run_Output,
        UpdateDate = @UpdateDate, --CURRENT_TIMESTAMP if Automatically set to the current timestamp
        UpdateBy = @UpdateBy
    WHERE DataProc_Run_Id = @DataProc_Run_Id AND DataProc_Id = @DataProc_Id
END

GO

