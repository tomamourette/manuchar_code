CREATE TABLE [10REF_mds].[mdm.Sales_Plan] (
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
    [Period_Type]          NVARCHAR (MAX) NULL,
    [Start_Date]           DATETIME2 (6)  NULL,
    [End_Date]             DATETIME2 (6)  NULL,
    [Periods]              DECIMAL (38)   NULL,
    [Factor]               DECIMAL (38)   NULL,
    [Ref_Start_Date]       DATETIME2 (6)  NULL,
    [Ref_End_Date]         DATETIME2 (6)  NULL,
    [Final_Version]        DECIMAL (38)   NULL,
    [Active_Code]          NVARCHAR (MAX) NULL,
    [Active_Name]          NVARCHAR (MAX) NULL,
    [Active_ID]            INT            NULL,
    [EnterDateTime]        DATETIME2 (6)  NULL,
    [EnterUserName]        NVARCHAR (MAX) NULL,
    [EnterVersionNumber]   INT            NULL,
    [LastChgDateTime]      DATETIME2 (6)  NULL,
    [LastChgUserName]      NVARCHAR (MAX) NULL,
    [LastChgVersionNumber] INT            NULL,
    [ValidationStatus]     NVARCHAR (MAX) NULL
);


GO

