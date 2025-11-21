CREATE TABLE [meta].[monitoring_transformation] (

	[workspace] varchar(255) NULL, 
	[status] varchar(255) NULL, 
	[timestamp] datetime2(0) NULL, 
	[duration] bigint NULL, 
	[pool_id] varchar(255) NULL, 
	[session_id] varchar(255) NULL, 
	[run_id] varchar(255) NULL, 
	[message] varchar(1000) NULL
);