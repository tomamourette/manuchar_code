CREATE TABLE [10REF_mds].[mdm.File_Types] (
    [ID]                   INT            NULL,
    [MUID]                 NVARCHAR (MAX) NULL,
    [VersionName]          NVARCHAR (MAX) NULL,
    [VersionNumber]        INT            NULL,
    [Version_ID]           INT            NULL,
    [VersionFlag]          NVARCHAR (MAX) NULL,
    [Name]                 NVARCHAR (MAX) NULL,
    [Code]                 NVARCHAR (MAX) NULL,
    [ChangeTrackingMask]   INT            NULL,
    [Type]                 NVARCHAR (MAX) NULL,
    [Effective_Date]       DATETIME2 (6)  NULL,
    [Pattern]              NVARCHAR (MAX) NULL,
    [Number_of_Columns]    DECIMAL (38)   NULL,
    [Field_Quote]          NVARCHAR (MAX) NULL,
    [Field_Terminator]     NVARCHAR (MAX) NULL,
    [Priority]             DECIMAL (38)   NULL,
    [Character_Set]        NVARCHAR (MAX) NULL,
    [File_Header]          NVARCHAR (MAX) NULL,
    [Import_Logic]         NVARCHAR (MAX) NULL,
    [Dataset]              NVARCHAR (MAX) NULL,
    [EnterDateTime]        DATETIME2 (6)  NULL,
    [EnterUserName]        NVARCHAR (MAX) NULL,
    [EnterVersionNumber]   INT            NULL,
    [LastChgDateTime]      DATETIME2 (6)  NULL,
    [LastChgUserName]      NVARCHAR (MAX) NULL,
    [LastChgVersionNumber] INT            NULL,
    [ValidationStatus]     NVARCHAR (MAX) NULL
);


GO

