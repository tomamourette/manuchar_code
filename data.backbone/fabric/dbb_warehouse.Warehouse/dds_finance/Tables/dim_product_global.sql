CREATE TABLE [dds_finance].[dim_product_global] (

	[tkey_product_global] bigint NULL, 
	[bkey_product_global] varchar(255) NULL, 
	[product_global_code] varchar(255) NULL, 
	[product_group] varchar(255) NULL, 
	[product_group_category] varchar(255) NULL, 
	[product_group_subcategory] varchar(255) NULL, 
	[product_business_unit] varchar(255) NULL, 
	[product_global_name] varchar(255) NULL, 
	[product_core] bit NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] bit NULL
);