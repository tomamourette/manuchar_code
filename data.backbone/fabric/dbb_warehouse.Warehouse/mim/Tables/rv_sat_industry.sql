CREATE TABLE [mim].[rv_sat_industry] (

	[bkey_industry_source] varchar(8000) NULL, 
	[industry_name] varchar(8000) NULL, 
	[industry_group] varchar(8000) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);