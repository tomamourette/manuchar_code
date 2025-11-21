CREATE TABLE [dds_finance].[dim_account] (

	[tkey_account] bigint NULL, 
	[bkey_account] varchar(255) NULL, 
	[account_number] varchar(8000) NULL, 
	[account_description] varchar(8000) NULL, 
	[account_full_description] varchar(8000) NOT NULL, 
	[account_type] varchar(8000) NULL, 
	[account_reporting_sign] decimal(38,0) NULL, 
	[account_running_total_sign] decimal(38,0) NULL, 
	[account_hierarchy_level_2] varchar(8000) NULL, 
	[account_hierarchy_level_3] varchar(8000) NULL, 
	[account_reporting_view] varchar(8000) NULL, 
	[account_hierarchy_level_1] varchar(8000) NULL, 
	[account_detail] decimal(38,0) NULL, 
	[account_sort_order] decimal(38,0) NULL, 
	[account_calculation_type] decimal(38,0) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] bit NULL
);