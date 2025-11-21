CREATE TABLE [dds_finance].[fact_financial_statements_kpi] (

	[tkey_kpi] int NULL, 
	[tkey_date] varchar(8000) NULL, 
	[tkey_company] bigint NULL, 
	[tkey_consolidation_period] bigint NULL, 
	[ytd_bundle_amount_act] decimal(38,2) NULL, 
	[ytd_conso_adjusted_amount_act] decimal(38,2) NULL, 
	[ytd_bundle_amount_bud] decimal(38,2) NULL, 
	[ytd_conso_adjusted_amount_bud] decimal(38,2) NULL, 
	[ytd_bundle_amount_fct] decimal(38,2) NULL, 
	[ytd_conso_adjusted_amount_fct] decimal(38,2) NULL
);