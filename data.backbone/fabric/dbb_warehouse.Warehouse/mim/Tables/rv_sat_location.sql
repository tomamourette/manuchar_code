CREATE TABLE [mim].[rv_sat_location] (

	[bkey_location_source] varchar(8000) NULL, 
	[location_name] varchar(8000) NULL, 
	[location_address] varchar(8000) NULL, 
	[location_city] varchar(8000) NULL, 
	[location_zip_code] varchar(8000) NULL, 
	[location_longitude] decimal(38,6) NULL, 
	[location_latitude] decimal(38,6) NULL, 
	[location_country_code] varchar(8000) NULL, 
	[location_type] varchar(8000) NULL, 
	[location_type_sort] varchar(8000) NULL, 
	[location_company] varchar(8000) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);