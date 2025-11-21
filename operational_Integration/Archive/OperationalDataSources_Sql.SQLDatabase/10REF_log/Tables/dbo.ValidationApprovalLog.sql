CREATE TABLE [10REF_log].[dbo.ValidationApprovalLog] (
    [ValidationApprovalLog] INT            NULL,
    [ValidationRunLog]      INT            NULL,
    [CompanyCode]           NVARCHAR (MAX) NULL,
    [ClosureDate]           NVARCHAR (MAX) NULL,
    [Status]                NVARCHAR (MAX) NULL,
    [FileName]              NVARCHAR (MAX) NULL,
    [InsertDate]            DATETIME2 (6)  NULL,
    [ModifiedBy]            NVARCHAR (MAX) NULL,
    [ModifiedOn]            DATETIME2 (6)  NULL
);


GO

