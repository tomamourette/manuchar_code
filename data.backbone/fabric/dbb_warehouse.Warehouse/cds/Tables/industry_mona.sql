CREATE TABLE [cds].[industry_mona] (

	[bkey_industry_source] varchar(8000) NULL, 
	[bkey_industry] varchar(8000) NULL, 
	[bkey_source] varchar(4) NOT NULL, 
	[industry_name] varchar(8000) NULL, 
	[industry_group] int NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);