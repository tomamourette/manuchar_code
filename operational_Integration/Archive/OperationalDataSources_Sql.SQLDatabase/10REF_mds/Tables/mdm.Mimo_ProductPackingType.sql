CREATE TABLE [10REF_mds].[mdm.Mimo_ProductPackingType] (
    [ID]                   INT            NULL,
    [MUID]                 NVARCHAR (MAX) NULL,
    [VersionName]          NVARCHAR (MAX) NULL,
    [VersionNumber]        INT            NULL,
    [Version_ID]           INT            NULL,
    [VersionFlag]          NVARCHAR (MAX) NULL,
    [Name]                 NVARCHAR (MAX) NULL,
    [Code]                 NVARCHAR (MAX) NULL,
    [ChangeTrackingMask]   INT            NULL,
    [Epicor_Type]          NVARCHAR (MAX) NULL,
    [Group_Code]           NVARCHAR (MAX) NULL,
    [Group_Name]           NVARCHAR (MAX) NULL,
    [Group_ID]             INT            NULL,
    [UsedInEKA_Code]       NVARCHAR (MAX) NULL,
    [UsedInEKA_Name]       NVARCHAR (MAX) NULL,
    [UsedInEKA_ID]         INT            NULL,
    [EnterDateTime]        DATETIME2 (6)  NULL,
    [EnterUserName]        NVARCHAR (MAX) NULL,
    [EnterVersionNumber]   INT            NULL,
    [LastChgDateTime]      DATETIME2 (6)  NULL,
    [LastChgUserName]      NVARCHAR (MAX) NULL,
    [LastChgVersionNumber] INT            NULL,
    [ValidationStatus]     NVARCHAR (MAX) NULL
);


GO

