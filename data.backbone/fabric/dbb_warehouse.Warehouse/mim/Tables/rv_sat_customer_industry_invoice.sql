CREATE TABLE [mim].[rv_sat_customer_industry_invoice] (

	[bkey_customer_industry_invoice_source] varchar(8000) NULL, 
	[customer_industry_invoice_name] varchar(8000) NULL, 
	[customer_industry_invoice_group] varchar(8000) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);