CREATE TABLE [mim].[rv_sat_incoterm] (

	[bkey_incoterm_source] varchar(8000) NULL, 
	[incoterm_code] varchar(8000) NULL, 
	[incoterm_description] int NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);