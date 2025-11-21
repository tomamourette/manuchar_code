CREATE TABLE [mim].[rv_sat_payment_term] (

	[bkey_payment_term_source] varchar(8000) NULL, 
	[payment_term_code] varchar(8000) NULL, 
	[payment_term_description] varchar(30) NULL, 
	[payment_term_number_of_days] varchar(30) NULL, 
	[valid_from] datetime2(6) NULL, 
	[valid_to] datetime2(6) NULL, 
	[is_current] int NOT NULL
);