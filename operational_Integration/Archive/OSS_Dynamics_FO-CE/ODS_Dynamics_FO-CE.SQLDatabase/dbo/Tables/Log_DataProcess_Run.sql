CREATE TABLE [dbo].[Log_DataProcess_Run] (
    [DataProc_Run_Id]               INT           NULL,
    [DataProc_Id]                   INT           NULL,
    [DataProc_Context]              VARCHAR (255) NULL,
    [DataProc_Run_Status]           VARCHAR (50)  NULL,
    [DataProc_Run_DateStart]        DATETIME      NULL,
    [DataProc_Run_DateEnd]          DATETIME      NULL,
    [DataProc_Run_DurationSec]      INT           NULL,
    [Run_NonCompletenessCheckCount] INT           NULL,
    [DataProc_Run_Output]           VARCHAR (255) NULL,
    [UpdateDate]                    DATETIME      NULL,
    [UpdateBy]                      VARCHAR (255) NULL
);


GO

