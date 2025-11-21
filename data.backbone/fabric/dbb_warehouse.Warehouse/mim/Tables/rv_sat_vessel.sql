CREATE TABLE [mim].[rv_sat_vessel] (

	[bkey_vessel_source] varchar(8000) NULL, 
	[vessel_id] varchar(8000) NULL, 
	[vessel_description] varchar(8000) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);