CREATE TABLE [mim].[rv_sat_business_unit] (

	[bkey_business_unit_source] varchar(8000) NULL, 
	[business_unit_name] varchar(8000) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);