CREATE TABLE [cds].[supplier_dynamics] (

	[bkey_supplier_source] varchar(8000) NOT NULL, 
	[bkey_supplier] varchar(8000) NOT NULL, 
	[bkey_source] varchar(8) NOT NULL, 
	[bkey_supplier_global] varchar(8000) NOT NULL, 
	[supplier_group] varchar(8000) NULL, 
	[supplier_group_description] varchar(8000) NULL, 
	[supplier_name] varchar(8000) NULL, 
	[supplier_id] varchar(8000) NULL, 
	[supplier_company] varchar(8000) NULL, 
	[supplier_address] varchar(8000) NULL, 
	[supplier_city] varchar(8000) NULL, 
	[supplier_zip_code] varchar(8000) NULL, 
	[supplier_affiliate] int NOT NULL, 
	[supplier_country_code] varchar(8000) NULL, 
	[supplier_legal_number] varchar(8000) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);