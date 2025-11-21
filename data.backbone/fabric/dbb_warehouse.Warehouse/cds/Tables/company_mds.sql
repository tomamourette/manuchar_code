CREATE TABLE [cds].[company_mds] (

	[bkey_company_source] varchar(8000) NULL, 
	[bkey_company] varchar(8000) NULL, 
	[bkey_source] varchar(3) NOT NULL, 
	[company_active_code] int NULL, 
	[company_tree_level_1] varchar(8000) NULL, 
	[company_tree_level_2] varchar(8000) NULL, 
	[company_name] varchar(8000) NULL, 
	[company_consolidation_method] int NULL, 
	[company_group_percentage] int NULL, 
	[company_minor_percentage] int NULL, 
	[company_group_control_percentage] int NULL, 
	[company_local_currency] int NULL, 
	[company_home_currency] int NULL, 
	[company_country_code] int NULL, 
	[company_min_reporting_period] int NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);