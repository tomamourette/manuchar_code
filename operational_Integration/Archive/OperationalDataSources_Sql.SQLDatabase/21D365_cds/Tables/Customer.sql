CREATE TABLE [21D365_cds].[Customer] (
    [customer_local_bk]          NVARCHAR (255) NOT NULL,
    [customer_global_bk]         NVARCHAR (255) NULL,
    [customer_local_id]          NVARCHAR (500) NULL,
    [customer_company_code]      NVARCHAR (50)  NULL,
    [customer_name]              NVARCHAR (255) NULL,
    [customer_address]           NVARCHAR (500) NULL,
    [customer_legal_number]      NVARCHAR (100) NULL,
    [customer_city]              NVARCHAR (255) NULL,
    [customer_zip_code]          NVARCHAR (50)  NULL,
    [customer_country]           NVARCHAR (50)  NULL,
    [customer_group]             NVARCHAR (100) NULL,
    [customer_industry]          NVARCHAR (100) NULL,
    [gkam]                       NVARCHAR (100) NULL,
    [multinational_name]         NVARCHAR (255) NULL,
    [multinational_legal_number] NVARCHAR (100) NULL,
    [affiliate]                  BIT            NULL,
    [source]                     NVARCHAR (50)  NULL,
    [CDSRecordStatus]            NCHAR (1)      NULL,
    [CDSStartDate]               DATETIME       NOT NULL,
    [CDSEndDate]                 DATETIME       NOT NULL,
    [CDSActive]                  BIT            NOT NULL,
    [CDSHashValue]               BINARY (16)    NOT NULL,
    PRIMARY KEY CLUSTERED ([customer_local_bk] ASC),
    CHECK ([CDSRecordStatus]='S' OR [CDSRecordStatus]='C' OR [CDSRecordStatus]='N')
);


GO

