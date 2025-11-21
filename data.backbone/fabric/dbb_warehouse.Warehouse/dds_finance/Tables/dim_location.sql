CREATE TABLE [dds_finance].[dim_location] (

	[tkey_location] bigint NULL, 
	[bkey_location] varchar(255) NULL, 
	[location_code] varchar(255) NULL, 
	[location_name] varchar(255) NULL, 
	[location_address] varchar(255) NULL, 
	[location_city] varchar(255) NULL, 
	[location_zip_code] varchar(255) NULL, 
	[location_longitude] decimal(18,0) NULL, 
	[location_latitude] decimal(18,0) NULL, 
	[location_country_code] varchar(2) NULL, 
	[location_type] varchar(50) NULL, 
	[location_type_sort] varchar(50) NULL, 
	[location_company] varchar(255) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] bit NULL
);