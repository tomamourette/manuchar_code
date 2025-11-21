CREATE TABLE [dds_finance].[dim_customer_industry_invoice] (

	[tkey_customer_industry_invoice] bigint NULL, 
	[bkey_customer_industry_invoice] varchar(255) NULL, 
	[customer_industry_invoice_code] varchar(255) NULL, 
	[customer_industry_invoice_description] varchar(255) NULL, 
	[customer_industry_invoice_group] varchar(255) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] bit NULL
);