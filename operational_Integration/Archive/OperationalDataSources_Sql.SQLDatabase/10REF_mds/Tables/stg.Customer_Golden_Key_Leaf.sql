CREATE TABLE [10REF_mds].[stg.Customer_Golden_Key_Leaf] (
    [ID]                      INT            NULL,
    [ImportType]              SMALLINT       NULL,
    [ImportStatus_ID]         SMALLINT       NULL,
    [Batch_ID]                INT            NULL,
    [BatchTag]                NVARCHAR (MAX) NULL,
    [ErrorCode]               INT            NULL,
    [Code]                    NVARCHAR (MAX) NULL,
    [Name]                    NVARCHAR (MAX) NULL,
    [NewCode]                 NVARCHAR (MAX) NULL,
    [Legal_Number]            NVARCHAR (MAX) NULL,
    [Country]                 NVARCHAR (MAX) NULL,
    [Address]                 NVARCHAR (MAX) NULL,
    [ZIP_Code]                NVARCHAR (MAX) NULL,
    [City]                    NVARCHAR (MAX) NULL,
    [Currency]                NVARCHAR (MAX) NULL,
    [Multinational_Number]    NVARCHAR (MAX) NULL,
    [Affiliate]               NVARCHAR (MAX) NULL,
    [Industry_Type]           NVARCHAR (MAX) NULL,
    [MNC_Parent]              NVARCHAR (MAX) NULL,
    [Latest_Annex_Number]     NVARCHAR (MAX) NULL,
    [Credendo_Debtor_Number]  NVARCHAR (MAX) NULL,
    [CpRefNo]                 NVARCHAR (MAX) NULL,
    [CpRefNo_Validation]      NVARCHAR (MAX) NULL,
    [CpRefNo_Validation_Date] DATETIME2 (6)  NULL
);


GO

