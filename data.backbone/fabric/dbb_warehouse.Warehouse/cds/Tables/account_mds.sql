CREATE TABLE [cds].[account_mds] (

	[bkey_account_source] varchar(8000) NULL, 
	[bkey_account] varchar(8000) NULL, 
	[bkey_source] varchar(3) NOT NULL, 
	[account_number] varchar(8000) NULL, 
	[account_description] varchar(8000) NULL, 
	[account_type] varchar(8000) NULL, 
	[account_reporting_sign] decimal(38,0) NULL, 
	[account_running_total_sign] decimal(38,0) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);