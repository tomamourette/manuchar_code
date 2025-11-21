CREATE TABLE [30MDS_stg].[mdm__Countries] (
    [ID]                     INT            NULL,
    [MUID]                   NVARCHAR (MAX) NULL,
    [VersionName]            NVARCHAR (MAX) NULL,
    [VersionNumber]          INT            NULL,
    [Version_ID]             INT            NULL,
    [VersionFlag]            NVARCHAR (MAX) NULL,
    [Name]                   NVARCHAR (MAX) NULL,
    [Code]                   NVARCHAR (MAX) NULL,
    [ChangeTrackingMask]     INT            NULL,
    [ISO_Alpha_3_Code]       NVARCHAR (MAX) NULL,
    [ISO_Numeric_Code]       NVARCHAR (MAX) NULL,
    [Commercial_Region_Code] NVARCHAR (MAX) NULL,
    [Commercial_Region_Name] NVARCHAR (MAX) NULL,
    [Commercial_Region_ID]   INT            NULL,
    [Previous_Region]        NVARCHAR (MAX) NULL,
    [EnterDateTime]          DATETIME2 (6)  NULL,
    [EnterUserName]          NVARCHAR (MAX) NULL,
    [EnterVersionNumber]     INT            NULL,
    [LastChgDateTime]        DATETIME2 (6)  NULL,
    [LastChgUserName]        NVARCHAR (MAX) NULL,
    [LastChgVersionNumber]   INT            NULL,
    [ValidationStatus]       NVARCHAR (MAX) NULL,
    [ODSHashValue]           BINARY (16)    NULL,
    [ODSRecordStatus]        NCHAR (1)      NULL
);


GO

