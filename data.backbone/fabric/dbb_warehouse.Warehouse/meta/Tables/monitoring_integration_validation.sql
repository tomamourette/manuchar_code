CREATE TABLE [meta].[monitoring_integration_validation] (

	[table_identifier] varchar(500) NULL, 
	[source_name] varchar(500) NULL, 
	[schema_table_name] varchar(500) NULL, 
	[workspace] varchar(500) NULL, 
	[row_count] bigint NULL, 
	[latest_ingestion_timestamp] datetime2(6) NULL, 
	[timestamp] datetime2(6) NULL
);