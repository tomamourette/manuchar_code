CREATE TABLE [cds].[consolidation_period_mona] (

	[bkey_consolidation_period_source] varchar(8000) NULL, 
	[bkey_consolidation_period] varchar(8000) NULL, 
	[bkey_source] varchar(4) NOT NULL, 
	[consolidation_id] int NULL, 
	[consolidation_name] varchar(8000) NULL, 
	[consolidation_year] smallint NULL, 
	[consolidation_month] int NULL, 
	[consolidation_date] datetime2(6) NULL, 
	[consolidation_version] int NULL, 
	[consolidation_category] varchar(8000) NULL, 
	[consolidation_category_description] varchar(8000) NULL, 
	[consolidation_scope] varchar(8000) NULL, 
	[consolidation_l4l_scope] varchar(8000) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);