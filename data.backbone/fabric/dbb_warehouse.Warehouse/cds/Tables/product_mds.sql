CREATE TABLE [cds].[product_mds] (

	[bkey_product_source] varchar(8000) NOT NULL, 
	[bkey_product] varchar(8000) NOT NULL, 
	[bkey_source] varchar(3) NOT NULL, 
	[product_name] varchar(8000) NULL, 
	[product_global_code] varchar(8000) NULL, 
	[product_company] varchar(8000) NULL, 
	[product_id] varchar(8000) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);