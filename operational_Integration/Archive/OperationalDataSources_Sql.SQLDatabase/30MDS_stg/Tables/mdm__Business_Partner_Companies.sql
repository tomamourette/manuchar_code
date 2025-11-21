CREATE TABLE [30MDS_stg].[mdm__Business_Partner_Companies] (
    [ID]                    INT            NULL,
    [MUID]                  NVARCHAR (MAX) NULL,
    [VersionName]           NVARCHAR (MAX) NULL,
    [VersionNumber]         INT            NULL,
    [Version_ID]            INT            NULL,
    [VersionFlag]           NVARCHAR (MAX) NULL,
    [Name]                  NVARCHAR (MAX) NULL,
    [Code]                  NVARCHAR (MAX) NULL,
    [ChangeTrackingMask]    INT            NULL,
    [Company_Code]          NVARCHAR (MAX) NULL,
    [Company_Name]          NVARCHAR (MAX) NULL,
    [Company_ID]            INT            NULL,
    [Legal_Number]          NVARCHAR (MAX) NULL,
    [Country_Code]          NVARCHAR (MAX) NULL,
    [Country_Name]          NVARCHAR (MAX) NULL,
    [Country_ID]            INT            NULL,
    [Address]               NVARCHAR (MAX) NULL,
    [ZIP_Code]              NVARCHAR (MAX) NULL,
    [City]                  NVARCHAR (MAX) NULL,
    [Legal_Number_Cleansed] NVARCHAR (MAX) NULL,
    [Business_Partner_Code] NVARCHAR (MAX) NULL,
    [Business_Partner_Name] NVARCHAR (MAX) NULL,
    [Business_Partner_ID]   INT            NULL,
    [Local_ID]              NVARCHAR (MAX) NULL,
    [Type]                  NVARCHAR (MAX) NULL,
    [EnterDateTime]         DATETIME2 (6)  NULL,
    [EnterUserName]         NVARCHAR (MAX) NULL,
    [EnterVersionNumber]    INT            NULL,
    [LastChgDateTime]       DATETIME2 (6)  NULL,
    [LastChgUserName]       NVARCHAR (MAX) NULL,
    [LastChgVersionNumber]  INT            NULL,
    [ValidationStatus]      NVARCHAR (MAX) NULL
);


GO

