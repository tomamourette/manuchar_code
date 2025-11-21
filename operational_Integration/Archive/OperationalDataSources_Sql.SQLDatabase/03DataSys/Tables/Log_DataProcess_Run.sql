CREATE TABLE [03DataSys].[Log_DataProcess_Run] (
    [DataProc_Run_Id]               INT           NOT NULL,
    [DataProc_Id]                   INT           NOT NULL,
    [DataProc_Context]              VARCHAR (255) NOT NULL,
    [DataProc_Run_Status]           VARCHAR (50)  NOT NULL,
    [DataProc_Run_DateStart]        DATETIME      NULL,
    [DataProc_Run_DateEnd]          DATETIME      NULL,
    [DataProc_Run_DurationSec]      INT           NULL,
    [Run_NonCompletenessCheckCount] INT           NULL,
    [DataProc_Run_Output]           VARCHAR (255) NULL,
    [UpdateDate]                    DATETIME      NULL,
    [UpdateBy]                      VARCHAR (255) NULL,
    PRIMARY KEY CLUSTERED ([DataProc_Run_Id] ASC)
);


GO

