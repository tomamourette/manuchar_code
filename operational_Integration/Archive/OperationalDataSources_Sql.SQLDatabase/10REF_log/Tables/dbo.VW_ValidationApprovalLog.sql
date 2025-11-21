CREATE TABLE [10REF_log].[dbo.VW_ValidationApprovalLog] (
    [ValidationApprovalLog] INT            NULL,
    [ValidationRunLog]      INT            NULL,
    [CompanyCode]           NVARCHAR (MAX) NULL,
    [ClosureDate]           NVARCHAR (MAX) NULL,
    [Status]                NVARCHAR (MAX) NULL,
    [FileName]              NVARCHAR (MAX) NULL,
    [InsertDate]            DATETIME2 (6)  NULL,
    [Whitelist]             NVARCHAR (MAX) NULL,
    [FileType]              NVARCHAR (MAX) NULL,
    [AdminUsers]            NVARCHAR (MAX) NULL
);


GO

