CREATE TABLE [10REF_mds].[mdm.Customer_To_Map] (
    [ID]                    INT            NULL,
    [MUID]                  NVARCHAR (MAX) NULL,
    [VersionName]           NVARCHAR (MAX) NULL,
    [VersionNumber]         INT            NULL,
    [Version_ID]            INT            NULL,
    [VersionFlag]           NVARCHAR (MAX) NULL,
    [Name]                  NVARCHAR (MAX) NULL,
    [Code]                  NVARCHAR (MAX) NULL,
    [ChangeTrackingMask]    INT            NULL,
    [Company_Name_Code]     NVARCHAR (MAX) NULL,
    [Company_Name_Name]     NVARCHAR (MAX) NULL,
    [Company_Name_ID]       INT            NULL,
    [Customer_ID]           NVARCHAR (MAX) NULL,
    [Legal_Number_Original] NVARCHAR (MAX) NULL,
    [Country_Code_Code]     NVARCHAR (MAX) NULL,
    [Country_Code_Name]     NVARCHAR (MAX) NULL,
    [Country_Code_ID]       INT            NULL,
    [Address]               NVARCHAR (MAX) NULL,
    [ZIP_Code]              NVARCHAR (MAX) NULL,
    [City]                  NVARCHAR (MAX) NULL,
    [Industry_Type_Code]    NVARCHAR (MAX) NULL,
    [Industry_Type_Name]    NVARCHAR (MAX) NULL,
    [Industry_Type_ID]      INT            NULL,
    [EnterDateTime]         DATETIME2 (6)  NULL,
    [EnterUserName]         NVARCHAR (MAX) NULL,
    [EnterVersionNumber]    INT            NULL,
    [LastChgDateTime]       DATETIME2 (6)  NULL,
    [LastChgUserName]       NVARCHAR (MAX) NULL,
    [LastChgVersionNumber]  INT            NULL,
    [ValidationStatus]      NVARCHAR (MAX) NULL
);


GO

