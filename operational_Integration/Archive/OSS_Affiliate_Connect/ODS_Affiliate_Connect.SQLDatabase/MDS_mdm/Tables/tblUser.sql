CREATE TABLE [MDS_mdm].[tblUser] (
    [ID]            INT            NULL,
    [MUID]          NVARCHAR (MAX) NULL,
    [Status_ID]     SMALLINT       NULL,
    [SID]           NVARCHAR (MAX) NULL,
    [UserName]      NVARCHAR (MAX) NULL,
    [DisplayName]   NVARCHAR (MAX) NULL,
    [Description]   NVARCHAR (MAX) NULL,
    [EmailAddress]  NVARCHAR (MAX) NULL,
    [LastLoginDTM]  DATETIME2 (6)  NULL,
    [EnterDTM]      DATETIME2 (6)  NULL,
    [EnterUserID]   INT            NULL,
    [LastChgDTM]    DATETIME2 (6)  NULL,
    [LastChgUserID] INT            NULL
);


GO

