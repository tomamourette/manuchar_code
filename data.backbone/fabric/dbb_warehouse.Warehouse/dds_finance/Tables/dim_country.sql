CREATE TABLE [dds_finance].[dim_country] (

	[tkey_country] bigint NULL, 
	[bkey_country] varchar(255) NULL, 
	[country_code] varchar(255) NULL, 
	[country_name] varchar(255) NULL, 
	[country_sort] int NULL, 
	[country_iso_code] varchar(255) NULL, 
	[region_level_1] varchar(255) NULL, 
	[region_level_1_sort] int NULL, 
	[region_level_2] varchar(255) NULL, 
	[region_level_2_sort] int NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] bit NULL
);