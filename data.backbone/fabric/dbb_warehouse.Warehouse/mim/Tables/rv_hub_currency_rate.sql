CREATE TABLE [mim].[rv_hub_currency_rate] (

	[bkey_currency_rate_source] varchar(8000) NOT NULL, 
	[bkey_currency_rate] varchar(8000) NOT NULL, 
	[bkey_source] varchar(4) NOT NULL, 
	[ldts] datetime2(6) NULL, 
	[record_source] varchar(25) NULL
);