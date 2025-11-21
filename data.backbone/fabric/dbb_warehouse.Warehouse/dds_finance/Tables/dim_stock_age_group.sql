CREATE TABLE [dds_finance].[dim_stock_age_group] (

	[tkey_stock_age_group] bigint NULL, 
	[bkey_stock_age_group] varchar(255) NULL, 
	[stock_age_group_code] varchar(255) NULL, 
	[stock_age_group_name] varchar(255) NULL, 
	[stock_age_group_id] varchar(255) NULL, 
	[stock_age_group_min_days] varchar(255) NULL, 
	[stock_age_group_max_days] varchar(255) NULL, 
	[stock_age_group_sort] varchar(255) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] bit NULL
);