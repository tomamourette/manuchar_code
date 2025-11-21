CREATE TABLE [30MDS_ods].[mdm__Customer_Mapping] (
    [ODSRowId]                 BIGINT         IDENTITY (1, 1) NOT NULL,
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
    [Customer_To_Map_Code]     NVARCHAR (MAX) NULL,
    [Customer_To_Map_Name]     NVARCHAR (MAX) NULL,
    [Customer_To_Map_ID]       INT            NULL,
    [EnterDateTime]            DATETIME2 (6)  NULL,
    [EnterUserName]            NVARCHAR (MAX) NULL,
    [EnterVersionNumber]       INT            NULL,
    [LastChgDateTime]          DATETIME2 (6)  NULL,
    [LastChgUserName]          NVARCHAR (MAX) NULL,
    [LastChgVersionNumber]     INT            NULL,
    [ValidationStatus]         NVARCHAR (MAX) NULL,
    [ODSStartDate]             DATETIME       NOT NULL,
    [ODSEndDate]               DATETIME       NOT NULL,
    [ODSActive]                BIT            NOT NULL,
    [ODSHashValue]             BINARY (16)    NOT NULL,
    CONSTRAINT [PK_mdm__Customer_Mapping] PRIMARY KEY CLUSTERED ([ODSRowId] ASC)
);


GO

