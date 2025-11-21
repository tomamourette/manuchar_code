CREATE TABLE [mim].[rv_sat_account_bc_delete] (

	[bkey_account_source] varchar(8000) NULL, 
	[account_number] varchar(8000) NULL, 
	[account_description] varchar(8000) NULL, 
	[account_type] varchar(8000) NULL, 
	[account_reporting_sign] decimal(38,0) NULL, 
	[account_running_total_sign] decimal(38,0) NULL, 
	[s_load_dt] datetime2(6) NULL, 
	[accounthierarchy_EnterDateTime] datetime2(6) NULL, 
	[ts_010s0_ingestion_timestamp] varchar(8000) NULL, 
	[accounthierarchy_LastChgDateTime] datetime2(6) NULL, 
	[src_load_dt] datetime2(6) NULL, 
	[is_deleted] int NOT NULL, 
	[model_exec_id] varchar(85) NOT NULL, 
	[s_hash_diff] varchar(401) NULL
);