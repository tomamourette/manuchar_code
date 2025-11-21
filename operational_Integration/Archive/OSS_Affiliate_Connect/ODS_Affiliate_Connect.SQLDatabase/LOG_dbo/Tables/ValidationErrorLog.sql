CREATE TABLE [LOG_dbo].[ValidationErrorLog] (
    [ValidationErrorLog]      INT            NULL,
    [ValidationRunLog]        INT            NULL,
    [ValidationRunDetailsLog] INT            NULL,
    [ValidationColumnId]      INT            NULL,
    [CompanyCode]             NVARCHAR (MAX) NULL,
    [RowNum]                  INT            NULL,
    [Value]                   NVARCHAR (MAX) NULL,
    [InsertDate]              DATETIME2 (6)  NULL
);


GO

