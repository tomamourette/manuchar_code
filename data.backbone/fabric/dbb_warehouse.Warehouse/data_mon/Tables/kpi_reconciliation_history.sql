CREATE TABLE [data_mon].[kpi_reconciliation_history] (

	[amount] decimal(38,2) NULL, 
	[reconciliation_pipeline_run_id] varchar(36) NOT NULL, 
	[orchestration_run_id] varchar(255) NULL, 
	[data_product] varchar(255) NULL, 
	[source_name] varchar(8000) NULL, 
	[kpi_name] varchar(8000) NULL, 
	[reconciliation_timestamp] datetime2(6) NULL
);