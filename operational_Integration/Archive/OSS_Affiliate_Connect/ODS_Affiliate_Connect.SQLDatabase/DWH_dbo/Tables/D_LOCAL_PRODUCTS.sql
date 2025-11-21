CREATE TABLE [DWH_dbo].[D_LOCAL_PRODUCTS] (
    [PK_LOCAL_PRODUCTS]                INT             NULL,
    [BK_LOCAL_PRODUCT]                 NVARCHAR (MAX)  NULL,
    [LOCAL_PRODUCT_NAME]               NVARCHAR (MAX)  NULL,
    [GROUP_PRODUCT_NAME]               NVARCHAR (MAX)  NULL,
    [GROUP_PRODUCT_CODE]               NVARCHAR (MAX)  NULL,
    [GROUP_PRODUCT_GROUP_NAME]         NVARCHAR (MAX)  NULL,
    [GROUP_PRODUCT_GROUP_BU]           NVARCHAR (MAX)  NULL,
    [GROUP_PRODUCT_GROUP_CATEGORY]     NVARCHAR (MAX)  NULL,
    [GROUP_PRODUCT_GROUP_SUB_CATEGORY] NVARCHAR (MAX)  NULL,
    [CAS]                              NVARCHAR (MAX)  NULL,
    [CHEMWATCH]                        NVARCHAR (MAX)  NULL,
    [MSDS_DATE]                        DATE            NULL,
    [HASHED_KEY_SCD1]                  NVARCHAR (MAX)  NULL,
    [IS_CURRENT]                       SMALLINT        NULL,
    [INSERT_DATE]                      DATETIME2 (6)   NULL,
    [UPDATE_DATE]                      DATETIME2 (6)   NULL,
    [START_DATE]                       DATETIME2 (6)   NULL,
    [END_DATE]                         DATETIME2 (6)   NULL,
    [MISSING_RECORD]                   VARBINARY (MAX) NULL,
    [PACKAGERUNID]                     INT             NULL
);


GO

