CREATE TABLE [10REF_dwh].[dbo.D_UOM] (
    [PK_UOM]             INT             NULL,
    [BK_UOM_CODE]        NVARCHAR (MAX)  NULL,
    [BK_UOM_NAME]        NVARCHAR (MAX)  NULL,
    [UOM_DESCRIPTION]    NVARCHAR (MAX)  NULL,
    [UOM_ConversionToMT] DECIMAL (38, 8) NULL,
    [HASHED_KEY_SCD1]    NVARCHAR (MAX)  NULL,
    [IS_CURRENT]         SMALLINT        NULL,
    [INSERT_DATE]        DATETIME2 (6)   NULL,
    [UPDATE_DATE]        DATETIME2 (6)   NULL,
    [START_DATE]         DATETIME2 (6)   NULL,
    [END_DATE]           DATETIME2 (6)   NULL,
    [MISSING_RECORD]     VARBINARY (MAX) NULL,
    [PACKAGERUNID]       INT             NULL
);


GO

