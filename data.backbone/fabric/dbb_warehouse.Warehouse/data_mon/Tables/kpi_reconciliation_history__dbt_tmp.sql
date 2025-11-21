CREATE TABLE [data_mon].[kpi_reconciliation_history__dbt_tmp] (

	[amount] decimal(38,2) NULL, 
	[source_name] varchar(8000) NULL, 
	[kpi_name] varchar(8000) NULL, 
	[reconciliation_pipeline_run_id] varchar(36) NOT NULL, 
	[orchestration_run_id] varchar(36) NOT NULL, 
	[data_product] varchar(25) NOT NULL, 
	[reconciliation_timestamp] datetime2(6) NULL
);