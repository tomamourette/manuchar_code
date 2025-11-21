CREATE TABLE [dds_finance].[fact_currency_rates] (

	[tkey_date] int NULL, 
	[tkey_currency] bigint NULL, 
	[currency_rate_consolidation_code] varchar(8000) NULL, 
	[currency_rate_reference_currency_code] varchar(8000) NULL, 
	[currency_rate_closing_rate] numeric(38,25) NULL, 
	[currency_rate_average_rate] numeric(38,25) NULL, 
	[currency_rate_average_month] numeric(38,25) NULL, 
	[currency_rate_budget_closing_rate] numeric(38,25) NULL, 
	[currency_rate_budget_average_rate] numeric(38,25) NULL, 
	[currency_rate_budget_average_month] numeric(38,25) NULL
);