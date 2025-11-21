CREATE TABLE [10REF_dwh].[dbo.D_PRODUCT_GROUPS] (
    [PK_PRODUCT_GROUPS]          INT             NULL,
    [BK_PRODUCT_GROUP]           NVARCHAR (MAX)  NULL,
    [PRODUCT_GROUP_NAME]         NVARCHAR (MAX)  NULL,
    [PRODUCT_GROUP_BU]           NVARCHAR (MAX)  NULL,
    [PRODUCT_GROUP_CATEGORY]     NVARCHAR (MAX)  NULL,
    [PRODUCT_GROUP_SUB_CATEGORY] NVARCHAR (MAX)  NULL,
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

