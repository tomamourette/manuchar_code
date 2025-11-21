
CREATE PROCEDURE [03DataSys].[SP_Update_DataProcess_RunStep](
    @DataProc_Run_Id INT,
    @DataProc_Run_Context VARCHAR(255),
    @DataProc_RunStep_Status VARCHAR(50),
    @DataProc_RunStep_UpdateContext VARCHAR(255),
    @DataProc_RunStep_DateStart DATETIME,
    @DataProc_RunStep_DateEnd DATETIME,
    @DataProc_RunStep_LogLastTransUpdateDate DATETIME,
    @RunStep_CheckCompleteness_SourceValue INT,
    @RunStep_CheckCompleteness_ControlValue INT,
    @DataProc_RunStep_Output VARCHAR(255),
    @UpdateBy VARCHAR(255)
)

AS
BEGIN
    -- Check if the record exists
    IF EXISTS (
        SELECT 1 
        FROM [03DataSys].Log_DataProcess_RunStep
        WHERE DataProc_Run_Context = @DataProc_Run_Context 
        AND DataProc_RunStep_DateStart = @DataProc_RunStep_DateStart
        AND DataProc_Run_Id = @DataProc_Run_Id
    )
    BEGIN
        -- Update the existing record
        UPDATE [03DataSys].Log_DataProcess_RunStep
        SET 
            DataProc_Run_Id = @DataProc_Run_Id,
            DataProc_Run_Context = @DataProc_Run_Context,
            DataProc_RunStep_Status = @DataProc_RunStep_Status,
            DataProc_RunStep_UpdateContext = @DataProc_RunStep_UpdateContext,
            DataProc_RunStep_DateStart = @DataProc_RunStep_DateStart,
            DataProc_RunStep_DateEnd = @DataProc_RunStep_DateEnd,
            DataProc_RunStep_DurationSec = DATEDIFF(SECOND, @DataProc_RunStep_DateStart, @DataProc_RunStep_DateEnd),
            DataProc_RunStep_LogLastTransUpdateDate = @DataProc_RunStep_LogLastTransUpdateDate,
            RunStep_CheckCompleteness_SourceValue = @RunStep_CheckCompleteness_SourceValue,
            RunStep_CheckCompleteness_ControlValue = @RunStep_CheckCompleteness_ControlValue,
            RunStep_CheckCompleteness_Diff =  @RunStep_CheckCompleteness_SourceValue - @RunStep_CheckCompleteness_ControlValue,
            DataProc_RunStep_Output = @DataProc_RunStep_Output,
            UpdateDate = GETDATE(),
            UpdateBy = @UpdateBy
        WHERE DataProc_Run_Context = @DataProc_Run_Context 
            AND DataProc_RunStep_DateStart = @DataProc_RunStep_DateStart
            AND DataProc_Run_Id = @DataProc_Run_Id
    END
    ELSE
    BEGIN
        -- Insert a new record
        INSERT INTO [03DataSys].Log_DataProcess_RunStep(
            DataProc_Run_Id, 
            DataProc_Run_Context, 
            DataProc_RunStep_Status, 
            DataProc_RunStep_UpdateContext, 
            DataProc_RunStep_DateStart, 
            DataProc_RunStep_Output,
            UpdateDate, 
            UpdateBy
        )
        VALUES (
            @DataProc_Run_Id, 
            @DataProc_Run_Context,
            @DataProc_RunStep_Status,
            @DataProc_RunStep_UpdateContext,
            @DataProc_RunStep_DateStart,
            @DataProc_RunStep_Output,
            GETDATE(),
            @UpdateBy
        );
        
    END
END

GO

