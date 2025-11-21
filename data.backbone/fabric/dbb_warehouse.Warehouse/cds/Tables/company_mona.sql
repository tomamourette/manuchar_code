CREATE TABLE [cds].[company_mona] (

	[bkey_company_source] varchar(8000) NULL, 
	[bkey_company] varchar(8000) NULL, 
	[bkey_source] varchar(4) NOT NULL, 
	[company_consolidation_method] varchar(8000) NULL, 
	[company_group_percentage] decimal(24,6) NULL, 
	[company_minor_percentage] decimal(24,6) NULL, 
	[company_group_control_percentage] decimal(24,6) NULL, 
	[company_tree_level_1] varchar(8000) NULL, 
	[company_tree_level_2] varchar(8000) NULL, 
	[company_name] varchar(8000) NULL, 
	[company_local_currency] varchar(8000) NULL, 
	[company_home_currency] varchar(8000) NULL, 
	[company_country_code] varchar(8000) NULL, 
	[company_min_reporting_period] varchar(48) NULL, 
	[company_active_code] int NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);