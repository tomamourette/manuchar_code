CREATE TABLE [meta].[monitoring_transformation_validation] (

	[validation_description] varchar(max) NULL, 
	[validation_type] varchar(max) NULL, 
	[validation_query] varchar(max) NULL, 
	[validation_expected_result] varchar(max) NULL, 
	[validation_result] varchar(max) NULL, 
	[status] varchar(max) NULL, 
	[database_name] varchar(max) NULL, 
	[table_name] varchar(max) NULL, 
	[timestamp] datetime2(6) NULL
);