CREATE TABLE [cds].[industry_mds] (

	[bkey_industry_source] varchar(8000) NULL, 
	[bkey_industry] varchar(8000) NULL, 
	[bkey_source] varchar(3) NOT NULL, 
	[industry_name] varchar(8000) NULL, 
	[industry_group] varchar(8000) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);