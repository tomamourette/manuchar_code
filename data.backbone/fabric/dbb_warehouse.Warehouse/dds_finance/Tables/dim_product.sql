CREATE TABLE [dds_finance].[dim_product] (

	[tkey_product] bigint NULL, 
	[bkey_product] varchar(255) NULL, 
	[product_code] varchar(255) NULL, 
	[product_global_code] varchar(255) NULL, 
	[product_name] varchar(255) NULL, 
	[product_company] varchar(255) NULL, 
	[product_id] varchar(255) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] bit NULL
);