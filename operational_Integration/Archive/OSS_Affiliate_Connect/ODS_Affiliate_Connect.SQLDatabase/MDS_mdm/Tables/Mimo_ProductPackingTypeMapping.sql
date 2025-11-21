CREATE TABLE [MDS_mdm].[Mimo_ProductPackingTypeMapping] (
    [ID]                     INT            NULL,
    [MUID]                   NVARCHAR (MAX) NULL,
    [VersionName]            NVARCHAR (MAX) NULL,
    [VersionNumber]          INT            NULL,
    [Version_ID]             INT            NULL,
    [VersionFlag]            NVARCHAR (MAX) NULL,
    [Name]                   NVARCHAR (MAX) NULL,
    [Code]                   NVARCHAR (MAX) NULL,
    [ChangeTrackingMask]     INT            NULL,
    [Product_Code]           NVARCHAR (MAX) NULL,
    [Product_Name]           NVARCHAR (MAX) NULL,
    [Product_ID]             INT            NULL,
    [Packing_Type_Code]      NVARCHAR (MAX) NULL,
    [Packing_Type_Name]      NVARCHAR (MAX) NULL,
    [Packing_Type_ID]        INT            NULL,
    [NeedsVerification_Code] NVARCHAR (MAX) NULL,
    [NeedsVerification_Name] NVARCHAR (MAX) NULL,
    [NeedsVerification_ID]   INT            NULL,
    [MTM_PackingType]        NVARCHAR (MAX) NULL,
    [EnterDateTime]          DATETIME2 (6)  NULL,
    [EnterUserName]          NVARCHAR (MAX) NULL,
    [EnterVersionNumber]     INT            NULL,
    [LastChgDateTime]        DATETIME2 (6)  NULL,
    [LastChgUserName]        NVARCHAR (MAX) NULL,
    [LastChgVersionNumber]   INT            NULL,
    [ValidationStatus]       NVARCHAR (MAX) NULL
);


GO

