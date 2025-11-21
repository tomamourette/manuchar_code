CREATE TABLE [dds_finance].[dim_payment_term] (

	[tkey_payment_term] bigint NULL, 
	[bkey_payment_term] varchar(255) NULL, 
	[payment_term_code] varchar(255) NULL, 
	[payment_term_description] varchar(255) NULL, 
	[number_of_days] varchar(50) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] bit NULL
);