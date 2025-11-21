CREATE TABLE [MDS_mdm].[Sales_Plan_Workflow] (
    [ID]                   INT            NULL,
    [MUID]                 NVARCHAR (MAX) NULL,
    [VersionName]          NVARCHAR (MAX) NULL,
    [VersionNumber]        INT            NULL,
    [Version_ID]           INT            NULL,
    [VersionFlag]          NVARCHAR (MAX) NULL,
    [Name]                 NVARCHAR (MAX) NULL,
    [Code]                 NVARCHAR (MAX) NULL,
    [ChangeTrackingMask]   INT            NULL,
    [Plan_Code]            NVARCHAR (MAX) NULL,
    [Plan_Name]            NVARCHAR (MAX) NULL,
    [Plan_ID]              INT            NULL,
    [Version]              DECIMAL (38)   NULL,
    [Company_Code]         NVARCHAR (MAX) NULL,
    [Company_Name]         NVARCHAR (MAX) NULL,
    [Company_ID]           INT            NULL,
    [User]                 NVARCHAR (MAX) NULL,
    [Role]                 NVARCHAR (MAX) NULL,
    [Active_Code]          NVARCHAR (MAX) NULL,
    [Active_Name]          NVARCHAR (MAX) NULL,
    [Active_ID]            INT            NULL,
    [Finished]             DATETIME2 (6)  NULL,
    [EnterDateTime]        DATETIME2 (6)  NULL,
    [EnterUserName]        NVARCHAR (MAX) NULL,
    [EnterVersionNumber]   INT            NULL,
    [LastChgDateTime]      DATETIME2 (6)  NULL,
    [LastChgUserName]      NVARCHAR (MAX) NULL,
    [LastChgVersionNumber] INT            NULL,
    [ValidationStatus]     NVARCHAR (MAX) NULL
);


GO

