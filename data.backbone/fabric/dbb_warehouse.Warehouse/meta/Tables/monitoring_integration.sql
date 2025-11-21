CREATE TABLE [meta].[monitoring_integration] (

	[table_name] varchar(255) NOT NULL, 
	[schema_name] varchar(255) NULL, 
	[source_name] varchar(255) NULL, 
	[source_type] varchar(255) NULL, 
	[load_type] varchar(255) NULL, 
	[workspace] varchar(255) NULL, 
	[status] varchar(255) NULL, 
	[timestamp] datetime2(0) NULL, 
	[duration] bigint NULL, 
	[throughput] decimal(18,2) NULL, 
	[data_read] bigint NULL, 
	[data_written] bigint NULL, 
	[rows_read] bigint NULL, 
	[rows_written] bigint NULL, 
	[data_product] varchar(255) NULL, 
	[orchestration_run_id] varchar(255) NULL, 
	[integration_pipeline_source_run_id] varchar(255) NULL, 
	[integration_pipeline_id] varchar(255) NULL
);