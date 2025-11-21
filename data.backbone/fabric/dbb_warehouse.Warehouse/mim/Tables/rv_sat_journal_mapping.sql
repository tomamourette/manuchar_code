CREATE TABLE [mim].[rv_sat_journal_mapping] (

	[bkey_journal_mapping_source] varchar(8000) NULL, 
	[bkey_journal_mapping] varchar(8000) NULL, 
	[bkey_source] varchar(13) NOT NULL, 
	[journal_mapping_code] varchar(8000) NULL, 
	[allocation] int NULL, 
	[bundle] int NULL, 
	[bundle_local_adjustments] int NULL, 
	[conso_adjusted] int NULL, 
	[conso_legal] int NULL, 
	[intercompany] int NULL, 
	[manual] int NULL, 
	[technical_eliminations] int NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);