CREATE TABLE [10REF_log].[LOG.CaseEvents] (
    [id]         INT            NULL,
    [caseID]     NVARCHAR (MAX) NULL,
    [event]      NVARCHAR (MAX) NULL,
    [user]       NVARCHAR (MAX) NULL,
    [timestamp]  DATETIME2 (6)  NULL,
    [createdOn]  DATETIME2 (6)  NULL,
    [createdBy]  NVARCHAR (MAX) NULL,
    [modifiedOn] DATETIME2 (6)  NULL,
    [modifiedBy] NVARCHAR (MAX) NULL
);


GO

