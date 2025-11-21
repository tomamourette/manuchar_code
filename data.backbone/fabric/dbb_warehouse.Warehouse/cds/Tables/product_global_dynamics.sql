CREATE TABLE [cds].[product_global_dynamics] (

	[bkey_product_global_source] varchar(8000) NULL, 
	[bkey_product_global] varchar(8000) NULL, 
	[bkey_source] varchar(8) NOT NULL, 
	[product_group] varchar(8000) NULL, 
	[product_group_category] varchar(8000) NULL, 
	[product_group_subcategory] varchar(8000) NULL, 
	[product_business_unit] varchar(8000) NULL, 
	[product_global_name] varchar(8000) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);