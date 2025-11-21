CREATE TABLE [cds].[account_header_mds] (

	[bkey_account_header_source] varchar(8000) NULL, 
	[bkey_account_header] varchar(8000) NULL, 
	[bkey_source] varchar(3) NULL, 
	[account_header_number] varchar(8000) NULL, 
	[account_header_type] varchar(8000) NULL, 
	[account_header_hierarchy_level_2] varchar(8000) NULL, 
	[account_header_hierarchy_level_3] varchar(8000) NULL, 
	[account_header_reporting_view] varchar(8000) NULL, 
	[account_header_hierarchy_level_1] varchar(8000) NULL, 
	[account_header_detail] decimal(38,0) NULL, 
	[account_header_sort_order] decimal(38,0) NULL, 
	[account_header_calculation_type] decimal(38,0) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);