CREATE TABLE [cds].[business_unit_mds] (

	[bkey_business_unit_source] varchar(8000) NULL, 
	[bkey_business_unit] varchar(8000) NULL, 
	[bkey_source] varchar(3) NOT NULL, 
	[business_unit_name] varchar(8000) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);