CREATE TABLE [MDS_stg].[Location_Mapping_Leaf] (
    [ID]                  INT            NULL,
    [ImportType]          SMALLINT       NULL,
    [ImportStatus_ID]     SMALLINT       NULL,
    [Batch_ID]            INT            NULL,
    [BatchTag]            NVARCHAR (MAX) NULL,
    [ErrorCode]           INT            NULL,
    [Code]                NVARCHAR (MAX) NULL,
    [Name]                NVARCHAR (MAX) NULL,
    [NewCode]             NVARCHAR (MAX) NULL,
    [Company]             NVARCHAR (MAX) NULL,
    [Local_Location_Code] NVARCHAR (MAX) NULL,
    [Group_Location_Code] NVARCHAR (MAX) NULL
);


GO

