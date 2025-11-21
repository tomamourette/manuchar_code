CREATE TABLE [LOG_LOG].[CaseAttributes] (
    [id]         INT            NULL,
    [caseID]     NVARCHAR (MAX) NULL,
    [company]    NVARCHAR (MAX) NULL,
    [domain]     NVARCHAR (MAX) NULL,
    [period]     DATE           NULL,
    [createdOn]  DATETIME2 (6)  NULL,
    [createdBy]  NVARCHAR (MAX) NULL,
    [modifiedOn] DATETIME2 (6)  NULL,
    [modifiedBy] NVARCHAR (MAX) NULL
);


GO

