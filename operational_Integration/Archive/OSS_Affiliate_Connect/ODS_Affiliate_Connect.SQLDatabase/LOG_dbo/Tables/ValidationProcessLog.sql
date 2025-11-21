CREATE TABLE [LOG_dbo].[ValidationProcessLog] (
    [ValidationProcessLog]    INT            NULL,
    [ValidationRunLog]        INT            NULL,
    [ValidationRunDetailsLog] INT            NULL,
    [CompanyCode]             NVARCHAR (MAX) NULL,
    [Severity]                INT            NULL,
    [Message]                 NVARCHAR (MAX) NULL,
    [Status]                  NVARCHAR (MAX) NULL,
    [InsertDate]              DATETIME2 (6)  NULL
);


GO

