CREATE TABLE [meta].[data_product_models] (

	[data_product] varchar(255) NULL, 
	[environment] varchar(50) NULL, 
	[workspace_id] uniqueidentifier NULL, 
	[model_id] uniqueidentifier NULL, 
	[is_active] bit NULL
);