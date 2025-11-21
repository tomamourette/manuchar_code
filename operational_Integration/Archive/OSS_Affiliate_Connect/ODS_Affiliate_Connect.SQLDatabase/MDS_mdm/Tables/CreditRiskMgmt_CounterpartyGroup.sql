CREATE TABLE [MDS_mdm].[CreditRiskMgmt_CounterpartyGroup] (
    [ID]                   INT            NULL,
    [MUID]                 NVARCHAR (MAX) NULL,
    [VersionName]          NVARCHAR (MAX) NULL,
    [VersionNumber]        INT            NULL,
    [Version_ID]           INT            NULL,
    [VersionFlag]          NVARCHAR (MAX) NULL,
    [Name]                 NVARCHAR (MAX) NULL,
    [Code]                 NVARCHAR (MAX) NULL,
    [ChangeTrackingMask]   INT            NULL,
    [BU]                   NVARCHAR (MAX) NULL,
    [Date_Last_Visit]      DATETIME2 (6)  NULL,
    [Related_Companies]    NVARCHAR (MAX) NULL,
    [Contact_Name]         NVARCHAR (MAX) NULL,
    [Contact_Function]     NVARCHAR (MAX) NULL,
    [Contact_Telephone]    NVARCHAR (MAX) NULL,
    [Contact_EMail]        NVARCHAR (MAX) NULL,
    [Contact_Website]      NVARCHAR (MAX) NULL,
    [Type_of_Activity]     NVARCHAR (MAX) NULL,
    [Activity]             NVARCHAR (MAX) NULL,
    [Destination_Region]   NVARCHAR (MAX) NULL,
    [Additional_People]    NVARCHAR (MAX) NULL,
    [EnterDateTime]        DATETIME2 (6)  NULL,
    [EnterUserName]        NVARCHAR (MAX) NULL,
    [EnterVersionNumber]   INT            NULL,
    [LastChgDateTime]      DATETIME2 (6)  NULL,
    [LastChgUserName]      NVARCHAR (MAX) NULL,
    [LastChgVersionNumber] INT            NULL,
    [ValidationStatus]     NVARCHAR (MAX) NULL
);


GO

