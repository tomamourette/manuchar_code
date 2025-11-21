CREATE TABLE [10REF_mds].[mdm.Industry_Types_Exceptions] (
    [ID]                       INT            NULL,
    [MUID]                     NVARCHAR (MAX) NULL,
    [VersionName]              NVARCHAR (MAX) NULL,
    [VersionNumber]            INT            NULL,
    [Version_ID]               INT            NULL,
    [VersionFlag]              NVARCHAR (MAX) NULL,
    [Name]                     NVARCHAR (MAX) NULL,
    [Code]                     NVARCHAR (MAX) NULL,
    [ChangeTrackingMask]       INT            NULL,
    [Customer_Golden_Key_Code] NVARCHAR (MAX) NULL,
    [Customer_Golden_Key_Name] NVARCHAR (MAX) NULL,
    [Customer_Golden_Key_ID]   INT            NULL,
    [Product_Code]             NVARCHAR (MAX) NULL,
    [Product_Name]             NVARCHAR (MAX) NULL,
    [Product_ID]               INT            NULL,
    [Industry_Type_Code]       NVARCHAR (MAX) NULL,
    [Industry_Type_Name]       NVARCHAR (MAX) NULL,
    [Industry_Type_ID]         INT            NULL,
    [EnterDateTime]            DATETIME2 (6)  NULL,
    [EnterUserName]            NVARCHAR (MAX) NULL,
    [EnterVersionNumber]       INT            NULL,
    [LastChgDateTime]          DATETIME2 (6)  NULL,
    [LastChgUserName]          NVARCHAR (MAX) NULL,
    [LastChgVersionNumber]     INT            NULL,
    [ValidationStatus]         NVARCHAR (MAX) NULL
);


GO

