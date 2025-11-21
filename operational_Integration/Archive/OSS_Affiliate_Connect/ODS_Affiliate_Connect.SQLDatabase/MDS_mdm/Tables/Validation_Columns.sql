CREATE TABLE [MDS_mdm].[Validation_Columns] (
    [ID]                   INT            NULL,
    [MUID]                 NVARCHAR (MAX) NULL,
    [VersionName]          NVARCHAR (MAX) NULL,
    [VersionNumber]        INT            NULL,
    [Version_ID]           INT            NULL,
    [VersionFlag]          NVARCHAR (MAX) NULL,
    [Name]                 NVARCHAR (MAX) NULL,
    [Code]                 NVARCHAR (MAX) NULL,
    [ChangeTrackingMask]   INT            NULL,
    [Validation_Code]      NVARCHAR (MAX) NULL,
    [Validation_Name]      NVARCHAR (MAX) NULL,
    [Validation_ID]        INT            NULL,
    [File_Column_Code]     NVARCHAR (MAX) NULL,
    [File_Column_Name]     NVARCHAR (MAX) NULL,
    [File_Column_ID]       INT            NULL,
    [Validation_Result]    NVARCHAR (MAX) NULL,
    [EnterDateTime]        DATETIME2 (6)  NULL,
    [EnterUserName]        NVARCHAR (MAX) NULL,
    [EnterVersionNumber]   INT            NULL,
    [LastChgDateTime]      DATETIME2 (6)  NULL,
    [LastChgUserName]      NVARCHAR (MAX) NULL,
    [LastChgVersionNumber] INT            NULL,
    [ValidationStatus]     NVARCHAR (MAX) NULL
);


GO

