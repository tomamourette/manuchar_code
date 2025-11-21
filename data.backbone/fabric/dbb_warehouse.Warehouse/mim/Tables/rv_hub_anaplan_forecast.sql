CREATE TABLE [mim].[rv_hub_anaplan_forecast] (

	[bkey_forecast_transaction_source] varchar(8000) NOT NULL, 
	[bkey_forecast_transaction] varchar(8000) NOT NULL, 
	[bkey_source] varchar(5) NOT NULL, 
	[ldts] datetime2(6) NULL, 
	[record_source] varchar(25) NULL
);