CREATE TABLE [meta].[m_model_exec] (

	[m_model_exec_id] varchar(250) NOT NULL, 
	[m_model_name] varchar(200) NULL, 
	[m_invocation_id] varchar(200) NULL, 
	[m_job_name] varchar(200) NULL, 
	[m_model_start_end] datetime2(6) NULL, 
	[m_model_materialized] varchar(50) NULL, 
	[m_row_count] int NULL
);