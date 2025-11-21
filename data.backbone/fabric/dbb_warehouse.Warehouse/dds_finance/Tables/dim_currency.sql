CREATE TABLE [dds_finance].[dim_currency] (

	[tkey_currency] bigint NULL, 
	[bkey_currency] varchar(255) NULL, 
	[currency_code] varchar(255) NULL, 
	[currency_description] varchar(255) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] bit NULL
);