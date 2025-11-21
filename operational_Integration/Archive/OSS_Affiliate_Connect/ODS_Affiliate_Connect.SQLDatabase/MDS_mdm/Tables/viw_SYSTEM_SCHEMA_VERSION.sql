CREATE TABLE [MDS_mdm].[viw_SYSTEM_SCHEMA_VERSION] (
    [ID]                   INT            NULL,
    [MUID]                 NVARCHAR (MAX) NULL,
    [Model_ID]             INT            NULL,
    [Model_MUID]           NVARCHAR (MAX) NULL,
    [Model_Name]           NVARCHAR (MAX) NULL,
    [Status_ID]            SMALLINT       NULL,
    [Status]               NVARCHAR (MAX) NULL,
    [VersionNbr]           INT            NULL,
    [Name]                 NVARCHAR (MAX) NULL,
    [Description]          NVARCHAR (MAX) NULL,
    [VersionFlag_ID]       INT            NULL,
    [Flag_MUID]            NVARCHAR (MAX) NULL,
    [Flag]                 NVARCHAR (MAX) NULL,
    [CopiedFrom_ID]        INT            NULL,
    [CopiedFrom_MUID]      NVARCHAR (MAX) NULL,
    [CopiedFrom]           NVARCHAR (MAX) NULL,
    [EnteredUser_ID]       INT            NULL,
    [EnteredUser_MUID]     NVARCHAR (MAX) NULL,
    [EnteredUser_UserName] NVARCHAR (MAX) NULL,
    [EnteredUser_DTM]      DATETIME2 (6)  NULL,
    [LastChgUser_ID]       INT            NULL,
    [LastChgUser_MUID]     NVARCHAR (MAX) NULL,
    [LastChgUser_UserName] NVARCHAR (MAX) NULL,
    [LastChgUser_DTM]      DATETIME2 (6)  NULL
);


GO

