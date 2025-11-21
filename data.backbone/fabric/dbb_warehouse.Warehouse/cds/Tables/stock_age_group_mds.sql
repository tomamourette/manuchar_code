CREATE TABLE [cds].[stock_age_group_mds] (

	[bkey_stock_age_group_source] varchar(8000) NULL, 
	[bkey_stock_age_group] varchar(8000) NULL, 
	[bkey_source] varchar(3) NOT NULL, 
	[stock_age_group_name] varchar(8000) NULL, 
	[stock_age_group_id] varchar(8000) NULL, 
	[stock_age_group_min_days] decimal(38,0) NULL, 
	[stock_age_group_max_days] decimal(38,0) NULL, 
	[stock_age_group_sort] decimal(38,0) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);