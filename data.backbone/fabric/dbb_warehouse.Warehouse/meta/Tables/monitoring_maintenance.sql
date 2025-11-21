CREATE TABLE [meta].[monitoring_maintenance] (

	[table_name] varchar(5000) NOT NULL, 
	[schema_name] varchar(5000) NOT NULL, 
	[source_name] varchar(5000) NOT NULL, 
	[environment] varchar(5000) NOT NULL, 
	[status] varchar(5000) NOT NULL, 
	[maintenance_type] varchar(5000) NOT NULL, 
	[duration] float NOT NULL, 
	[maintenance_timestamp] varchar(5000) NOT NULL
);