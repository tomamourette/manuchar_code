CREATE TABLE [cds].[currency_mona] (

	[bkey_currency_source] varchar(8000) NULL, 
	[bkey_currency] varchar(8000) NULL, 
	[bkey_source] varchar(4) NOT NULL, 
	[currency_name] varchar(8000) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);