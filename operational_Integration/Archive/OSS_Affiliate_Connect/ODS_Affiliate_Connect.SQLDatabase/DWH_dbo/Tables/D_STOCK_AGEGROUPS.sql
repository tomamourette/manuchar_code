CREATE TABLE [DWH_dbo].[D_STOCK_AGEGROUPS] (
    [PK_STOCK_AGEGROUPS]         INT             NULL,
    [BK_STOCK_AGEGROUP_MINDAYS]  DECIMAL (38)    NULL,
    [STOCK_AGEGROUP_MAXDAYS]     DECIMAL (38)    NULL,
    [STOCK_AGEGROUP_POSITION]    DECIMAL (38)    NULL,
    [STOCK_AGEGROUP_DESCRIPTION] NVARCHAR (MAX)  NULL,
    [HASHED_KEY_SCD1]            NVARCHAR (MAX)  NULL,
    [IS_CURRENT]                 SMALLINT        NULL,
    [INSERT_DATE]                DATETIME2 (6)   NULL,
    [UPDATE_DATE]                DATETIME2 (6)   NULL,
    [START_DATE]                 DATETIME2 (6)   NULL,
    [END_DATE]                   DATETIME2 (6)   NULL,
    [MISSING_RECORD]             VARBINARY (MAX) NULL,
    [PACKAGERUNID]               INT             NULL
);


GO

