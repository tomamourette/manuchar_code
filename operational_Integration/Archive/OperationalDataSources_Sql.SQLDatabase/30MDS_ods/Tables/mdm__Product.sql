CREATE TABLE [30MDS_ods].[mdm__Product] (
    [ODSRowId]             BIGINT         IDENTITY (1, 1) NOT NULL,
    [ID]                   INT            NULL,
    [MUID]                 NVARCHAR (MAX) NULL,
    [VersionName]          NVARCHAR (MAX) NULL,
    [VersionNumber]        INT            NULL,
    [Version_ID]           INT            NULL,
    [VersionFlag]          NVARCHAR (MAX) NULL,
    [Name]                 NVARCHAR (MAX) NULL,
    [Code]                 NVARCHAR (MAX) NULL,
    [ChangeTrackingMask]   INT            NULL,
    [HS_Code]              NVARCHAR (MAX) NULL,
    [Services_Code]        NVARCHAR (MAX) NULL,
    [Services_Name]        NVARCHAR (MAX) NULL,
    [Services_ID]          INT            NULL,
    [Product_ID]           NVARCHAR (MAX) NULL,
    [EnterDateTime]        DATETIME2 (6)  NULL,
    [EnterUserName]        NVARCHAR (MAX) NULL,
    [EnterVersionNumber]   INT            NULL,
    [LastChgDateTime]      DATETIME2 (6)  NULL,
    [LastChgUserName]      NVARCHAR (MAX) NULL,
    [LastChgVersionNumber] INT            NULL,
    [ValidationStatus]     NVARCHAR (MAX) NULL,
    [ODSStartDate]         DATETIME       NOT NULL,
    [ODSEndDate]           DATETIME       NOT NULL,
    [ODSActive]            BIT            NOT NULL,
    [ODSHashValue]         BINARY (16)    NOT NULL,
    CONSTRAINT [PK_mdm__Product] PRIMARY KEY CLUSTERED ([ODSRowId] ASC)
);


GO

