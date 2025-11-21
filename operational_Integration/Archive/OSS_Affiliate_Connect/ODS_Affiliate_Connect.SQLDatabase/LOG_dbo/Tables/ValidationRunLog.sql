CREATE TABLE [LOG_dbo].[ValidationRunLog] (
    [ValidationRunLog]     INT            NULL,
    [LogicAppRunId]        NVARCHAR (MAX) NULL,
    [FromEmailAdress]      NVARCHAR (MAX) NULL,
    [Flg_Error_WhiteList]  BIT            NULL,
    [Flg_Error_Attachment] BIT            NULL,
    [StartDate]            DATETIME2 (6)  NULL,
    [EndDate]              DATETIME2 (6)  NULL,
    [Status]               NVARCHAR (MAX) NULL
);


GO

