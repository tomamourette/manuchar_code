CREATE TABLE [cds].[customer_industry_invoice_dynamics] (

	[bkey_customer_industry_invoice_source] varchar(201) NULL, 
	[bkey_customer_industry_invoice] varchar(192) NULL, 
	[bkey_source] varchar(8) NOT NULL, 
	[customer_industry_invoice_name] int NULL, 
	[customer_industry_invoice_group] int NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);