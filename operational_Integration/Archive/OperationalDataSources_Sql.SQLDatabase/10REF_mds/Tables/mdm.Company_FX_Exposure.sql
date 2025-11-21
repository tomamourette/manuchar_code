CREATE TABLE [10REF_mds].[mdm.Company_FX_Exposure] (
    [ID]                   INT             NULL,
    [MUID]                 NVARCHAR (MAX)  NULL,
    [VersionName]          NVARCHAR (MAX)  NULL,
    [VersionNumber]        INT             NULL,
    [Version_ID]           INT             NULL,
    [VersionFlag]          NVARCHAR (MAX)  NULL,
    [Name]                 NVARCHAR (MAX)  NULL,
    [Code]                 NVARCHAR (MAX)  NULL,
    [ChangeTrackingMask]   INT             NULL,
    [Closure_Date]         DATETIME2 (6)   NULL,
    [Company_Code]         NVARCHAR (MAX)  NULL,
    [Company_Name]         NVARCHAR (MAX)  NULL,
    [Company_ID]           INT             NULL,
    [Receivables_in_USD]   DECIMAL (38, 2) NULL,
    [Inventory_in_USD]     DECIMAL (38, 2) NULL,
    [AP_in_USD]            DECIMAL (38, 2) NULL,
    [Cash_in_USD]          DECIMAL (38, 2) NULL,
    [Loans_in_USD]         DECIMAL (38, 2) NULL,
    [Local_Hedges_in_USD]  DECIMAL (38, 2) NULL,
    [Group_Hedges_in_USD]  DECIMAL (38, 2) NULL,
    [EnterDateTime]        DATETIME2 (6)   NULL,
    [EnterUserName]        NVARCHAR (MAX)  NULL,
    [EnterVersionNumber]   INT             NULL,
    [LastChgDateTime]      DATETIME2 (6)   NULL,
    [LastChgUserName]      NVARCHAR (MAX)  NULL,
    [LastChgVersionNumber] INT             NULL,
    [ValidationStatus]     NVARCHAR (MAX)  NULL
);


GO

