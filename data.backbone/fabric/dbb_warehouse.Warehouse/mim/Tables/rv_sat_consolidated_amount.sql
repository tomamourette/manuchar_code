CREATE TABLE [mim].[rv_sat_consolidated_amount] (

	[bkey_consolidated_amount_source] varchar(8000) NOT NULL, 
	[consolidated_account] varchar(8000) NULL, 
	[consolidated_consolidation_period] varchar(8000) NULL, 
	[consolidated_company] varchar(8000) NULL, 
	[consolidated_currency] varchar(8000) NULL, 
	[consolidated_partner_company] varchar(8000) NULL, 
	[consolidated_industry] varchar(8000) NULL, 
	[consolidated_journal_type] varchar(8000) NULL, 
	[consolidated_journal_category] varchar(8000) NULL, 
	[consolidated_amount] decimal(38,6) NULL, 
	[consolidated_bundle_local_adjustment_amount] decimal(38,6) NULL, 
	[consolidated_bundle_local_amount] decimal(38,6) NULL, 
	[valid_from] varchar(26) NOT NULL, 
	[valid_to] varchar(26) NOT NULL, 
	[is_current] int NOT NULL
);