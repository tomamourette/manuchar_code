CREATE TABLE [cds].[kpi_items_dbb_lakehouse] (

	[tkey_kpi] int NULL, 
	[bkey_kpi] varchar(8000) NULL, 
	[bkey_kpi_source] varchar(8000) NULL, 
	[bkey_source] varchar(8) NULL, 
	[kpi_name] varchar(8000) NULL, 
	[kpi_sort_number] float NULL, 
	[kpi_type] varchar(8000) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);