CREATE TABLE [DWH_dbo].[D_BUSINESSTYPES] (
    [PK_BUSINESSTYPES]            INT             NULL,
    [BK_BUSINESSTYPE_DESCRIPTION] NVARCHAR (MAX)  NULL,
    [HASHED_KEY_SCD1]             NVARCHAR (MAX)  NULL,
    [IS_CURRENT]                  SMALLINT        NULL,
    [INSERT_DATE]                 DATETIME2 (6)   NULL,
    [UPDATE_DATE]                 DATETIME2 (6)   NULL,
    [START_DATE]                  DATETIME2 (6)   NULL,
    [END_DATE]                    DATETIME2 (6)   NULL,
    [MISSING_RECORD]              VARBINARY (MAX) NULL,
    [PACKAGERUNID]                INT             NULL
);


GO

