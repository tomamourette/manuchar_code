CREATE TABLE [cds].[incoterm_dynamics] (

	[bkey_incoterm_source] varchar(8000) NULL, 
	[bkey_incoterm] varchar(8000) NULL, 
	[bkey_source] varchar(8) NOT NULL, 
	[incoterm_description] int NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);