CREATE TABLE [10REF_mds].[stg.Sales_Plan_Workflow_Leaf] (
    [ID]              INT            NULL,
    [ImportType]      SMALLINT       NULL,
    [ImportStatus_ID] SMALLINT       NULL,
    [Batch_ID]        INT            NULL,
    [BatchTag]        NVARCHAR (MAX) NULL,
    [ErrorCode]       INT            NULL,
    [Code]            NVARCHAR (MAX) NULL,
    [Name]            NVARCHAR (MAX) NULL,
    [NewCode]         NVARCHAR (MAX) NULL,
    [Role]            NVARCHAR (MAX) NULL,
    [Plan]            NVARCHAR (MAX) NULL,
    [Version]         DECIMAL (38)   NULL,
    [Company]         NVARCHAR (MAX) NULL,
    [Active]          NVARCHAR (MAX) NULL,
    [Finished]        DATETIME2 (6)  NULL,
    [User]            NVARCHAR (MAX) NULL
);


GO

