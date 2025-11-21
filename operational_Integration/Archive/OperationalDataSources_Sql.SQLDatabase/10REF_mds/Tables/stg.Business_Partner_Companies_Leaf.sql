CREATE TABLE [10REF_mds].[stg.Business_Partner_Companies_Leaf] (
    [ID]                    INT            NULL,
    [ImportType]            SMALLINT       NULL,
    [ImportStatus_ID]       SMALLINT       NULL,
    [Batch_ID]              INT            NULL,
    [BatchTag]              NVARCHAR (MAX) NULL,
    [ErrorCode]             INT            NULL,
    [Code]                  NVARCHAR (MAX) NULL,
    [Name]                  NVARCHAR (MAX) NULL,
    [NewCode]               NVARCHAR (MAX) NULL,
    [Legal_Number]          NVARCHAR (MAX) NULL,
    [ZIP_Code]              NVARCHAR (MAX) NULL,
    [City]                  NVARCHAR (MAX) NULL,
    [Local_ID]              NVARCHAR (MAX) NULL,
    [Address]               NVARCHAR (MAX) NULL,
    [Type]                  NVARCHAR (MAX) NULL,
    [Company]               NVARCHAR (MAX) NULL,
    [Country]               NVARCHAR (MAX) NULL,
    [Legal_Number_cleansed] NVARCHAR (MAX) NULL,
    [Business_Partner]      NVARCHAR (MAX) NULL
);


GO

