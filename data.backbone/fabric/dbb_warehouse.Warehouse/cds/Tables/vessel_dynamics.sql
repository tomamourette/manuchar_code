CREATE TABLE [cds].[vessel_dynamics] (

	[bkey_vessel_source] varchar(8000) NULL, 
	[bkey_vessel] varchar(8000) NULL, 
	[bkey_source] varchar(8) NOT NULL, 
	[vessel_description] varchar(8000) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);