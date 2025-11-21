CREATE TABLE [MDS_stg].[Business_Partner_Leaf] (
    [ID]                             INT            NULL,
    [ImportType]                     SMALLINT       NULL,
    [ImportStatus_ID]                SMALLINT       NULL,
    [Batch_ID]                       INT            NULL,
    [BatchTag]                       NVARCHAR (MAX) NULL,
    [ErrorCode]                      INT            NULL,
    [Code]                           NVARCHAR (MAX) NULL,
    [Name]                           NVARCHAR (MAX) NULL,
    [NewCode]                        NVARCHAR (MAX) NULL,
    [Legal_Number_Original]          NVARCHAR (MAX) NULL,
    [Legal_Number_Cleansed]          NVARCHAR (MAX) NULL,
    [Country]                        NVARCHAR (MAX) NULL,
    [Multinational_Parent]           NVARCHAR (MAX) NULL,
    [Multinational_Business_Partner] NVARCHAR (MAX) NULL,
    [Address]                        NVARCHAR (MAX) NULL,
    [City]                           NVARCHAR (MAX) NULL,
    [Zip]                            NVARCHAR (MAX) NULL,
    [Is_Intercompany]                NVARCHAR (MAX) NULL,
    [Indusrty_Type]                  NVARCHAR (MAX) NULL
);


GO

