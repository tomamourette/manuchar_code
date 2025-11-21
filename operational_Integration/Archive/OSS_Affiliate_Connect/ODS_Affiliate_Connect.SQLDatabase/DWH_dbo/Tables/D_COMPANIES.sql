CREATE TABLE [DWH_dbo].[D_COMPANIES] (
    [PK_COMPANIES]                        INT             NULL,
    [BK_COMPANYCODE]                      NVARCHAR (MAX)  NULL,
    [COMPANY_NAME]                        NVARCHAR (MAX)  NULL,
    [COMPANY_HOMECURRENCY]                NVARCHAR (MAX)  NULL,
    [COMPANY_LEGALNUMBER]                 NVARCHAR (MAX)  NULL,
    [COMPANY_BUSINESSTYPE]                NVARCHAR (MAX)  NULL,
    [COMPANY_COMMERCIALREGION]            NVARCHAR (MAX)  NULL,
    [COMPANY_COUNTRY]                     NVARCHAR (MAX)  NULL,
    [COMPANY_COUNTRYMANAGER]              NVARCHAR (MAX)  NULL,
    [COMPANY_HRCONTACT]                   NVARCHAR (MAX)  NULL,
    [COMPANY_ITCONTACT]                   NVARCHAR (MAX)  NULL,
    [COMPANY_ACTIVE_FLAG]                 NVARCHAR (MAX)  NULL,
    [COMPANY_DEBTOR_REPORTING_FLAG]       NVARCHAR (MAX)  NULL,
    [COMPANY_SALES_REPORTING_FLAG]        NVARCHAR (MAX)  NULL,
    [COMPANY_STOCK_REPORTING_FLAG]        NVARCHAR (MAX)  NULL,
    [COMPANY_PAYABLES_REPORTING_FLAG]     NVARCHAR (MAX)  NULL,
    [COMPANY_CONSOLIDATION_POINT_OF_VIEW] NVARCHAR (MAX)  NULL,
    [COMPANY_CONSOLIDATION_SEGMENT]       NVARCHAR (MAX)  NULL,
    [COMPANY_CONSOLIDATION_METHOD]        NVARCHAR (MAX)  NULL,
    [HASHED_KEY_SCD1]                     NVARCHAR (MAX)  NULL,
    [IS_CURRENT]                          SMALLINT        NULL,
    [INSERT_DATE]                         DATETIME2 (6)   NULL,
    [UPDATE_DATE]                         DATETIME2 (6)   NULL,
    [START_DATE]                          DATETIME2 (6)   NULL,
    [END_DATE]                            DATETIME2 (6)   NULL,
    [MISSING_RECORD]                      VARBINARY (MAX) NULL,
    [PACKAGERUNID]                        INT             NULL
);


GO

