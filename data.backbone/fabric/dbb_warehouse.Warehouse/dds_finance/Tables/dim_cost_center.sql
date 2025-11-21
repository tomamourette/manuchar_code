CREATE TABLE [dds_finance].[dim_cost_center] (

	[tkey_cost_center] bigint NULL, 
	[bkey_cost_center] varchar(255) NULL, 
	[cost_center_code] varchar(255) NULL, 
	[cost_center_description] varchar(255) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] bit NULL
);