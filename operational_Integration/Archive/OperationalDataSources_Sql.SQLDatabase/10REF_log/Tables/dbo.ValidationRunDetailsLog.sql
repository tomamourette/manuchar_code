CREATE TABLE [10REF_log].[dbo.ValidationRunDetailsLog] (
    [ValidationRunDetailsLog] INT            NULL,
    [ValidationRunLog]        INT            NULL,
    [FileName]                NVARCHAR (MAX) NULL,
    [FileType]                NVARCHAR (MAX) NULL,
    [Flg_Error_FileName]      BIT            NULL,
    [Flg_Error_Columns]       BIT            NULL,
    [Flg_Error_Validation]    BIT            NULL,
    [StartDate]               DATETIME2 (6)  NULL,
    [EndDate]                 DATETIME2 (6)  NULL,
    [Status]                  NVARCHAR (MAX) NULL,
    [CompanyCode]             NVARCHAR (MAX) NULL
);


GO

