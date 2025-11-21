CREATE TABLE [MDS_mdm].[Mimo_ProductAttributeMapping] (
    [ID]                                    INT            NULL,
    [MUID]                                  NVARCHAR (MAX) NULL,
    [VersionName]                           NVARCHAR (MAX) NULL,
    [VersionNumber]                         INT            NULL,
    [Version_ID]                            INT            NULL,
    [VersionFlag]                           NVARCHAR (MAX) NULL,
    [Name]                                  NVARCHAR (MAX) NULL,
    [Code]                                  NVARCHAR (MAX) NULL,
    [ChangeTrackingMask]                    INT            NULL,
    [Product_Code]                          NVARCHAR (MAX) NULL,
    [Product_Name]                          NVARCHAR (MAX) NULL,
    [Product_ID]                            INT            NULL,
    [MTM_Product]                           NVARCHAR (MAX) NULL,
    [Attribute_Code]                        NVARCHAR (MAX) NULL,
    [Attribute_Name]                        NVARCHAR (MAX) NULL,
    [Attribute_ID]                          INT            NULL,
    [MTM_Attribute]                         NVARCHAR (MAX) NULL,
    [Quality_Classification_Attribute_Code] NVARCHAR (MAX) NULL,
    [Quality_Classification_Attribute_Name] NVARCHAR (MAX) NULL,
    [Quality_Classification_Attribute_ID]   INT            NULL,
    [Contract_Attribute_Code]               NVARCHAR (MAX) NULL,
    [Contract_Attribute_Name]               NVARCHAR (MAX) NULL,
    [Contract_Attribute_ID]                 INT            NULL,
    [Stock_Attribute_Code]                  NVARCHAR (MAX) NULL,
    [Stock_Attribute_Name]                  NVARCHAR (MAX) NULL,
    [Stock_Attribute_ID]                    INT            NULL,
    [EnterDateTime]                         DATETIME2 (6)  NULL,
    [EnterUserName]                         NVARCHAR (MAX) NULL,
    [EnterVersionNumber]                    INT            NULL,
    [LastChgDateTime]                       DATETIME2 (6)  NULL,
    [LastChgUserName]                       NVARCHAR (MAX) NULL,
    [LastChgVersionNumber]                  INT            NULL,
    [ValidationStatus]                      NVARCHAR (MAX) NULL
);


GO

