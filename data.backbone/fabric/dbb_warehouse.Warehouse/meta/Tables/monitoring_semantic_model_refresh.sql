CREATE TABLE [meta].[monitoring_semantic_model_refresh] (

	[workspace_id] varchar(100) NULL, 
	[semantic_model_id] varchar(100) NULL, 
	[data_product] varchar(100) NULL, 
	[orchestration_run_id] varchar(100) NULL, 
	[process_started_at] datetime2(3) NULL, 
	[process_completed_at] datetime2(3) NULL, 
	[duration] bigint NULL, 
	[status] varchar(50) NULL, 
	[data_product_refresh_pipeline_run_id] varchar(255) NULL, 
	[data_product_refresh_pipeline_id] varchar(255) NULL
);