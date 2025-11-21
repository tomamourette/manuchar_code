CREATE TABLE [cds].[logistics_file_dynamics] (

	[tkey_logistic_file] bigint NULL, 
	[bkey_logistic_file] varchar(8000) NULL, 
	[bkey_logistic_file_source] varchar(8000) NULL, 
	[bkey_source] varchar(8) NULL, 
	[bkey_purchase_order] varchar(8000) NULL, 
	[bkey_sales_order] varchar(8000) NULL, 
	[center_id_to] varchar(8000) NULL, 
	[center_id_from] varchar(8000) NULL, 
	[unit_id] varchar(8000) NULL, 
	[customer_reference] varchar(8000) NULL, 
	[mnr_transport_document_reference] varchar(8000) NULL, 
	[mnr_voyage_number] varchar(8000) NULL, 
	[mnr_vessel_id] varchar(8000) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);