CREATE TABLE [LOG_dbo].[VW_ValidationApprovalLogs] (
    [ValidationApprovalLog] INT            NULL,
    [ValidationRunLog]      INT            NULL,
    [CompanyCode]           NVARCHAR (MAX) NULL,
    [ClosureDate]           NVARCHAR (MAX) NULL,
    [Status]                NVARCHAR (MAX) NULL,
    [FileName]              NVARCHAR (MAX) NULL,
    [InsertDate]            DATETIME2 (6)  NULL,
    [Whitelist]             NVARCHAR (MAX) NULL,
    [FileType]              NVARCHAR (MAX) NULL,
    [Type]                  NVARCHAR (MAX) NULL,
    [AdminUsers]            NVARCHAR (MAX) NULL,
    [ClosureDate_Date]      DATE           NULL
);


GO

