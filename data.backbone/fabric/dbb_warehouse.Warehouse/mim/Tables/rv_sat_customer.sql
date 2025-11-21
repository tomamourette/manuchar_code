CREATE TABLE [mim].[rv_sat_customer] (

	[bkey_customer_source] varchar(8000) NOT NULL, 
	[customer_code] varchar(8000) NOT NULL, 
	[bkey_customer_global] varchar(8000) NOT NULL, 
	[customer_company] varchar(8000) NULL, 
	[customer_id] varchar(8000) NULL, 
	[customer_name] varchar(8000) NULL, 
	[customer_address] varchar(8000) NULL, 
	[customer_legal_number] varchar(8000) NULL, 
	[customer_city] varchar(8000) NULL, 
	[customer_zip_code] varchar(8000) NULL, 
	[customer_group] varchar(8000) NULL, 
	[customer_group_description] varchar(8000) NULL, 
	[customer_industry] varchar(8000) NULL, 
	[customer_multinational_legal_number] varchar(8000) NULL, 
	[customer_multinational_name] varchar(8000) NULL, 
	[customer_gkam] int NULL, 
	[customer_affiliate] int NULL, 
	[customer_country_code] varchar(8000) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);