CREATE TABLE [mim].[rv_sat_currency] (

	[bkey_currency_source] varchar(8000) NULL, 
	[currency_name] varchar(8000) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);