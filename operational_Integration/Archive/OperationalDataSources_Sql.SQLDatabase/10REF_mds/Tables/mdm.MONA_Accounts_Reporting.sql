CREATE TABLE [10REF_mds].[mdm.MONA_Accounts_Reporting] (
    [ID]                       INT            NULL,
    [MUID]                     NVARCHAR (MAX) NULL,
    [VersionName]              NVARCHAR (MAX) NULL,
    [VersionNumber]            INT            NULL,
    [Version_ID]               INT            NULL,
    [VersionFlag]              NVARCHAR (MAX) NULL,
    [Name]                     NVARCHAR (MAX) NULL,
    [Code]                     NVARCHAR (MAX) NULL,
    [ChangeTrackingMask]       INT            NULL,
    [Reporting_View]           NVARCHAR (MAX) NULL,
    [Account_Code]             NVARCHAR (MAX) NULL,
    [Account_Name]             NVARCHAR (MAX) NULL,
    [Account_ID]               INT            NULL,
    [MONA_Account_Header_Code] NVARCHAR (MAX) NULL,
    [MONA_Account_Header_Name] NVARCHAR (MAX) NULL,
    [MONA_Account_Header_ID]   INT            NULL,
    [Subheader]                NVARCHAR (MAX) NULL,
    [Subheader2]               NVARCHAR (MAX) NULL,
    [Sign]                     DECIMAL (38)   NULL,
    [EnterDateTime]            DATETIME2 (6)  NULL,
    [EnterUserName]            NVARCHAR (MAX) NULL,
    [EnterVersionNumber]       INT            NULL,
    [LastChgDateTime]          DATETIME2 (6)  NULL,
    [LastChgUserName]          NVARCHAR (MAX) NULL,
    [LastChgVersionNumber]     INT            NULL,
    [ValidationStatus]         NVARCHAR (MAX) NULL
);


GO

