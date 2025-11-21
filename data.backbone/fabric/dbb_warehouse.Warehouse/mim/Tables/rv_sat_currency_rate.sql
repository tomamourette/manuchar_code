CREATE TABLE [mim].[rv_sat_currency_rate] (

	[bkey_currency_rate_source] varchar(8000) NOT NULL, 
	[currency_rate_consolidation_id] int NULL, 
	[currency_rate_consolidation_code] varchar(8000) NULL, 
	[currency_rate_currency_code] varchar(8000) NULL, 
	[currency_rate_reference_currency_code] varchar(8000) NULL, 
	[currency_rate_closing_rate] numeric(38,25) NULL, 
	[currency_rate_average_rate] numeric(38,25) NULL, 
	[currency_rate_average_month] numeric(38,25) NULL, 
	[currency_rate_budget_closing_rate] numeric(38,25) NULL, 
	[currency_rate_budget_average_rate] numeric(38,25) NULL, 
	[currency_rate_budget_average_month] numeric(38,25) NULL, 
	[currency_rate_month] int NULL, 
	[currency_rate_year] smallint NULL, 
	[currency_rate_closing_date] date NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);