CREATE PROCEDURE [03DataSys].[SP_Update_DataProcess_Run](
    @DataProc_Run_Id VARCHAR(255),
    @DataProc_Id INT,
    @DataProc_Context VARCHAR(255),
    @DataProc_Run_Status VARCHAR(50),
    @DataProc_Run_DateStart DATETIME2(3),
    @DataProc_Run_DateEnd DATETIME2(3),
    @DataProc_Run_DurationSec INT,
    @Run_NonCompletenessCheckCount INT,
    @DataProc_Run_Output VARCHAR(50),
    @UpdateBy VARCHAR(50)
)
AS
BEGIN
    -- Update the DataProcess_Run table with the provided parameters
    INSERT INTO [03DataSys].Log_DataProcess_Run(DataProc_Run_Id, DataProc_Id, DataProc_Context, DataProc_Run_Status, DataProc_Run_DateStart, DataProc_Run_DateEnd, DataProc_Run_DurationSec, Run_NonCompletenessCheckCount, DataProc_Run_Output, UpdateDate, UpdateBy)
    VALUES (
        @DataProc_Run_Id,
        @DataProc_Id, 
        @DataProc_Context,
        @DataProc_Run_Status,
        @DataProc_Run_DateStart,
        @DataProc_Run_DateEnd,
        @DataProc_Run_DurationSec,
        @Run_NonCompletenessCheckCount,
        @DataProc_Run_Output,
        getdate(), --if Automatically set to the current timestamp
        @UpdateBy
        )
END