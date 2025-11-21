CREATE TABLE [mim].[rv_sat_product] (

	[bkey_product_source] varchar(100) NULL, 
	[product_global_code] varchar(50) NULL, 
	[product_name] varchar(255) NULL, 
	[product_company] varchar(50) NULL, 
	[product_id] varchar(100) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);