CREATE TABLE [10REF_dwh].[dbo.D_BUSINESSUNITS] (
    [PK_BUSINESSUNITS]            INT             NULL,
    [BK_BUSINESSUNIT_DESCRIPTION] NVARCHAR (MAX)  NULL,
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

