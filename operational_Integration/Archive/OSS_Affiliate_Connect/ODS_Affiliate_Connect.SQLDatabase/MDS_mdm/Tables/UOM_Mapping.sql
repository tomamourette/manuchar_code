CREATE TABLE [MDS_mdm].[UOM_Mapping] (
    [ID]                   INT            NULL,
    [MUID]                 NVARCHAR (MAX) NULL,
    [VersionName]          NVARCHAR (MAX) NULL,
    [VersionNumber]        INT            NULL,
    [Version_ID]           INT            NULL,
    [VersionFlag]          NVARCHAR (MAX) NULL,
    [Name]                 NVARCHAR (MAX) NULL,
    [Code]                 NVARCHAR (MAX) NULL,
    [ChangeTrackingMask]   INT            NULL,
    [Company_Code]         NVARCHAR (MAX) NULL,
    [Company_Name]         NVARCHAR (MAX) NULL,
    [Company_ID]           INT            NULL,
    [Local_UOM_Code]       NVARCHAR (MAX) NULL,
    [Group_UOM_Code_Code]  NVARCHAR (MAX) NULL,
    [Group_UOM_Code_Name]  NVARCHAR (MAX) NULL,
    [Group_UOM_Code_ID]    INT            NULL,
    [EnterDateTime]        DATETIME2 (6)  NULL,
    [EnterUserName]        NVARCHAR (MAX) NULL,
    [EnterVersionNumber]   INT            NULL,
    [LastChgDateTime]      DATETIME2 (6)  NULL,
    [LastChgUserName]      NVARCHAR (MAX) NULL,
    [LastChgVersionNumber] INT            NULL,
    [ValidationStatus]     NVARCHAR (MAX) NULL
);


GO

