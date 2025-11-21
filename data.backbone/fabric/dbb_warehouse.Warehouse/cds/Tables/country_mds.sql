CREATE TABLE [cds].[country_mds] (

	[bkey_country_source] varchar(8000) NULL, 
	[bkey_country] varchar(8000) NULL, 
	[bkey_source] varchar(3) NOT NULL, 
	[country_name] varchar(8000) NULL, 
	[country_iso_code] varchar(8000) NULL, 
	[country_sort] varchar(8000) NULL, 
	[country_region_level_1] int NULL, 
	[country_region_level_1_sort] int NULL, 
	[country_region_level_2] varchar(8000) NULL, 
	[country_region_level_2_sort] int NULL, 
	[country_continent] int NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);