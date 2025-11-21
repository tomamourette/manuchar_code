CREATE TABLE [dbo].[Log_DataProcess_RunStep] (
    [DataProc_RunStep_Id]                     INT           NULL,
    [DataProc_Run_Id]                         INT           NULL,
    [DataProc_Run_Context]                    VARCHAR (255) NULL,
    [DataProc_RunStep_Status]                 VARCHAR (50)  NULL,
    [DataProc_RunStep_UpdateContext]          VARCHAR (255) NULL,
    [DataProc_RunStep_DateStart]              DATETIME      NULL,
    [DataProc_RunStep_DateEnd]                DATETIME      NULL,
    [DataProc_RunStep_DurationSec]            INT           NULL,
    [DataProc_RunStep_LogLastTransUpdateDate] DATETIME      NULL,
    [RunStep_CheckCompleteness_SourceValue]   INT           NULL,
    [RunStep_CheckCompleteness_ControlValue]  INT           NULL,
    [RunStep_CheckCompleteness_Diff]          INT           NULL,
    [DataProc_RunStep_Output]                 TEXT          NULL,
    [UpdateDate]                              DATETIME      NULL,
    [UpdateBy]                                VARCHAR (255) NULL
);


GO

