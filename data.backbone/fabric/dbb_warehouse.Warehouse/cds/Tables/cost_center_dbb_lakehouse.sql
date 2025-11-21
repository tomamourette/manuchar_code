CREATE TABLE [cds].[cost_center_dbb_lakehouse] (

	[bkey_cost_center_source] varchar(8000) NULL, 
	[bkey_cost_center] varchar(8000) NULL, 
	[bkey_source] varchar(13) NOT NULL, 
	[cost_center_code] varchar(8000) NULL, 
	[cost_center_description] varchar(8000) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);