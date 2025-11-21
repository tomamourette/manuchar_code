CREATE TABLE [dds_finance].[dim_consolidation_period] (

	[tkey_consolidation_period] bigint NULL, 
	[bkey_consolidation_period] varchar(255) NULL, 
	[consolidation_id] bigint NULL, 
	[consolidation_code] varchar(255) NULL, 
	[consolidation_name] varchar(255) NULL, 
	[consolidation_year] int NULL, 
	[consolidation_month] int NULL, 
	[consolidation_date] datetime2(6) NULL, 
	[consolidation_version] int NULL, 
	[consolidation_category] varchar(255) NULL, 
	[consolidation_category_description] varchar(255) NULL, 
	[consolidation_scope] varchar(255) NULL, 
	[consolidation_L4L_scope] varchar(255) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] bit NULL
);