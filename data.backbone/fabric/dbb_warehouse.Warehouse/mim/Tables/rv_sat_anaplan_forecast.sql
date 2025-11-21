CREATE TABLE [mim].[rv_sat_anaplan_forecast] (

	[tkey_forecast_transaction] varchar(8000) NOT NULL, 
	[bkey_forecast_transaction_source] varchar(8000) NOT NULL, 
	[sales_amount_group_currency] varchar(8000) NULL, 
	[quantity_in_metric_ton] varchar(8000) NULL, 
	[cogs_group_currency] varchar(8000) NULL, 
	[cogs2_group_currency] varchar(8000) NULL, 
	[gross_profit_group_currency] varchar(8000) NULL, 
	[home_currency] varchar(8000) NULL, 
	[plan_rate] varchar(8000) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);