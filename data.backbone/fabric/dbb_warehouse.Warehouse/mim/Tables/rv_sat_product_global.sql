CREATE TABLE [mim].[rv_sat_product_global] (

	[bkey_product_global_source] varchar(100) NULL, 
	[product_global_name] varchar(100) NULL, 
	[product_group] varchar(100) NULL, 
	[product_group_category] varchar(100) NULL, 
	[product_group_subcategory] varchar(100) NULL, 
	[product_business_unit] varchar(100) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);