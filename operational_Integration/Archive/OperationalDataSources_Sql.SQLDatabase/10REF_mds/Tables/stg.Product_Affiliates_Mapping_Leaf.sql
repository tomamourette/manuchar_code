CREATE TABLE [10REF_mds].[stg.Product_Affiliates_Mapping_Leaf] (
    [ID]                  INT             NULL,
    [ImportType]          SMALLINT        NULL,
    [ImportStatus_ID]     SMALLINT        NULL,
    [Batch_ID]            INT             NULL,
    [BatchTag]            NVARCHAR (MAX)  NULL,
    [ErrorCode]           INT             NULL,
    [Code]                NVARCHAR (MAX)  NULL,
    [Name]                NVARCHAR (MAX)  NULL,
    [NewCode]             NVARCHAR (MAX)  NULL,
    [Product]             NVARCHAR (MAX)  NULL,
    [Company]             NVARCHAR (MAX)  NULL,
    [Packaging_Type]      NVARCHAR (MAX)  NULL,
    [Quality]             DECIMAL (38, 2) NULL,
    [Packaging_Size]      DECIMAL (38, 2) NULL,
    [Packaging_UOM]       NVARCHAR (MAX)  NULL,
    [Form]                NVARCHAR (MAX)  NULL,
    [Grade]               NVARCHAR (MAX)  NULL,
    [Specification]       NVARCHAR (MAX)  NULL,
    [HS_Code]             NVARCHAR (MAX)  NULL,
    [Local_Product_Code]  NVARCHAR (MAX)  NULL,
    [CAS]                 NVARCHAR (MAX)  NULL,
    [Chemwatch]           NVARCHAR (MAX)  NULL,
    [MSDS_Date]           DATETIME2 (6)   NULL,
    [IMDG_Classification] NVARCHAR (MAX)  NULL
);


GO

