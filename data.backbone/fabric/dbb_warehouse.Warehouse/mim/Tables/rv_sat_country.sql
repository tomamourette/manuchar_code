CREATE TABLE [mim].[rv_sat_country] (

	[bkey_country_source] varchar(8000) NULL, 
	[country_name] varchar(8000) NULL, 
	[country_iso_code] varchar(8000) NULL, 
	[country_sort] varchar(8000) NULL, 
	[country_region_level_1] int NULL, 
	[country_region_level_1_sort] int NULL, 
	[country_region_level_2] varchar(8000) NULL, 
	[country_region_level_2_sort] int NULL, 
	[country_continent] varchar(8000) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);