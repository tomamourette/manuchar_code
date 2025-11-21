CREATE TABLE [30MDS_stg].[mdm__City_Mapping] (
    [ID]                   INT            NULL,
    [MUID]                 NVARCHAR (MAX) NULL,
    [VersionName]          NVARCHAR (MAX) NULL,
    [VersionNumber]        INT            NULL,
    [Version_ID]           INT            NULL,
    [VersionFlag]          NVARCHAR (MAX) NULL,
    [Name]                 NVARCHAR (MAX) NULL,
    [Code]                 NVARCHAR (MAX) NULL,
    [ChangeTrackingMask]   INT            NULL,
    [E10_Country]          NVARCHAR (MAX) NULL,
    [EKA_City_name]        NVARCHAR (MAX) NULL,
    [EKA_Country_Code]     NVARCHAR (MAX) NULL,
    [EKA_Country_Name]     NVARCHAR (MAX) NULL,
    [EKA_Country_ID]       INT            NULL,
    [UAT_Code]             NVARCHAR (MAX) NULL,
    [UAT_Name]             NVARCHAR (MAX) NULL,
    [UAT_ID]               INT            NULL,
    [Comment]              NVARCHAR (MAX) NULL,
    [Address_Suffix]       NVARCHAR (MAX) NULL,
    [EnterDateTime]        DATETIME2 (6)  NULL,
    [EnterUserName]        NVARCHAR (MAX) NULL,
    [EnterVersionNumber]   INT            NULL,
    [LastChgDateTime]      DATETIME2 (6)  NULL,
    [LastChgUserName]      NVARCHAR (MAX) NULL,
    [LastChgVersionNumber] INT            NULL,
    [ValidationStatus]     NVARCHAR (MAX) NULL
);


GO

